require 'rails'
module Kaltha
  class Railtie < ::Rails::Railtie

    config.before_initialize do
      puts "Running!"
      Dragonfly.send(:include, ::Kaltha::Dragonfly::DataStorage)
      Dragonfly.send(:include, ::Kaltha::Dragonfly::ActiveModelExtensions)
      ActiveRecord::Base.send(:include, ::Kaltha::CustomPathExtension)
      ActiveRecord::Base.send(:extend, ::Kaltha::Dragonfly::ActiveModelExtensions::ClassMethods)
    end
    # railtie code goes here
  end
end