require 'rails'
module DragonflyRails
  class Railtie < ::Rails::Railtie
    config.dragonflyrails = DragonflyRails
    initializer 'dragonfly_rails.extend_dragonfly', :before => 'dragonfly_rails.active_record' do
      puts "1"
      ds_type = (Rails.env.production? || Rails.env.staging?) ? 's3' : 'fs'
      puts ds_type
      require File.expand_path("../data_storage/#{ds_type}", __FILE__)
    end
    initializer 'dragonfly_rails.active_record' do
      puts "2"
      ActiveRecord::Base.send(:extend, ::DragonflyRails::Dragonfly::ActiveModelExtensions::ClassMethods)
      ActiveRecord::Base.send(:include, ::DragonflyRails::CustomPathExtension)
    end
    initializer 'dragonfly_rails.load_extension', :after => 'dragonfly_rails.active_record' do
      puts "3"
      @app = ::Dragonfly[:images]
      @app.configure_with(:rails)
      @app.configure_with(:imagemagick)
      if Rails.env.production? || Rails.env.staging?
        puts "Production!"
        @app.configure_with(:heroku, STORAGE_OPTIONS[:bucket])
      else
        Rails.configuration.dragonflyrails.assets_path = Rails.root.join('public','assets') if Rails.configuration.dragonflyrails.assets_path == :default
        @app.datastore.root_path = Rails.configuration.dragonflyrails.assets_path
      end
      @app.define_macro(ActiveRecord::Base, :image_accessor)
      @app.configure do |c|
        c.protect_from_dos_attacks = Rails.configuration.dragonflyrails.protect_from_dos_attacks
        c.secret = Rails.configuration.dragonflyrails.security_key
      end
    end
    config.app_middleware do
      insert_after 'Rack::Lock', 'Dragonfly::Middleware', :images, "/#{Rails.configuration.dragonflyrails.route_path}"
    end
    # railtie code goes here
  end
end