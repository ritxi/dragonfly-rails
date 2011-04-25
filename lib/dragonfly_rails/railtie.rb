require 'rails'
module DragonflyRails
  class Railtie < ::Rails::Railtie
    config.dragonfly_rails = DragonflyRails
    initializer 'dragonfly_rails.extend_dragonfly', :before => 'dragonfly_rails.active_record' do
      datastore_type = (Rails.env.production? || Rails.env.staging?) ? 's3' : 'fs'
      require File.expand_path("../data_storage/#{datastore_type}", __FILE__)
    end
    initializer 'dragonfly_rails.active_record' do
      ::ActiveRecord::Base.send(:extend, ::DragonflyRails::Dragonfly::ActiveModelExtensions::ClassMethods)
      ::ActiveRecord::Base.send(:include, ::DragonflyRails::CustomPathExtension)
    end
    initializer 'dragonfly_rails.load_extension', :after => 'dragonfly_rails.active_record' do
      if ::Rails.configuration.dragonfly_rails.assets_path == :default
        ::Rails.configuration.dragonfly_rails.assets_path = Rails.root.join('public','assets')
      end
      config = ::Rails.configuration.dragonfly_rails
      @app = ::Dragonfly[:images]
      @app.configure_with(:imagemagick)
      @app.configure do |c|
        c.protect_from_dos_attacks = config.protect_from_dos_attacks
        c.secret = config.security_key
        c.log = ::Rails.logger
        if ::Rails.env.production? || ::Rails.env.staging?
          @app.configure_with(:heroku, STORAGE_OPTIONS[:bucket])
        else
          if c.datastore.is_a?(::Dragonfly::DataStorage::FileDataStore)
            c.datastore.root_path = config.assets_path.to_s
            c.datastore.server_root = ::Rails.root.join('public').to_s
          end
        end
        c.url_format = "/#{config.route_path}/:job/:basename.:format"
        c.analyser.register(::Dragonfly::Analysis::FileCommandAnalyser)
      end
      @app.define_macro(::ActiveRecord::Base, :image_accessor)
    end
    initializer 'load asset dispatcher', :after => 'dragonfly_rails.load_extension' do |app|
      app.middleware.insert_after ::Rack::Lock, ::Dragonfly::Middleware, :images
    end
    # railtie code goes here
  end
end