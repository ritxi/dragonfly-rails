require 'rails'
module Kaltha
  class Railtie < ::Rails::Railtie
    config.kaltha = Kaltha
    initializer 'kaltha.extend_dragonfly', :before => 'kaltha.active_record' do
      puts "1"
      ds_type = (Rails.env.production? || Rails.env.staging?) ? 's3' : 'fs'
      puts ds_type
      require File.expand_path("../data_storage/#{ds_type}", __FILE__)
    end
    initializer 'kaltha.active_record' do
      puts "2"
      ActiveRecord::Base.send(:extend, ::Kaltha::Dragonfly::ActiveModelExtensions::ClassMethods)
      ActiveRecord::Base.send(:include, ::Kaltha::CustomPathExtension)
    end
    initializer 'kaltha.load_extension', :after => 'kaltha.active_record' do
      puts "3"
      @app = ::Dragonfly[:images]
      @app.configure_with(:rails)
      @app.configure_with(:imagemagick)
      if Rails.env.production? || Rails.env.staging?
        puts "Production!"
        @app.configure_with(:heroku, STORAGE_OPTIONS[:bucket])
      else
        Rails.configuration.kaltha.assets_path = Rails.root.join('public','assets') if Rails.configuration.kaltha.assets_path == :default
        @app.datastore.root_path = Rails.configuration.kaltha.assets_path
      end
      @app.define_macro(ActiveRecord::Base, :image_accessor)
      @app.configure do |c|
        c.protect_from_dos_attacks = Rails.configuration.kaltha.protect_from_dos_attacks
        c.secret = Rails.configuration.kaltha.security_key
      end
    end
    config.app_middleware do
      insert_after 'Rack::Lock', 'Dragonfly::Middleware', :images, "/#{Rails.configuration.kaltha.route_path}"
    end
    # railtie code goes here
  end
end