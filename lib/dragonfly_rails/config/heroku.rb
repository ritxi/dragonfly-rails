module Dragonfly
  module Config
    module Heroku
      def self.apply_configuration(app, options)
        app.configure do |c|
          c.datastore = DataStorage::S3DataStore.new
          c.datastore.configure do |d|
            credentials = self.parse_credentials(options[:s3_credentials]) if options[:s3_credentials]
            d.bucket_name = options[:bucket]
            d.access_key_id = credentials[:access_key_id] || ENV['S3_KEY'] || raise("ENV variable 'S3_KEY' needs to be set - use\n\theroku config:add S3_KEY=XXXXXXXXX")
            d.secret_access_key = credentials[:secret_access_key] || ENV['S3_SECRET'] || raise("ENV variable 'S3_SECRET' needs to be set - use\n\theroku config:add S3_SECRET=XXXXXXXXX")
          end
        end
        
      end
      def self.parse_credentials creds
        creds = Heroku.find_credentials(creds).stringify_keys
        (creds[::Rails.env] || creds).symbolize_keys
      end
      def self.find_credentials creds
        case creds
        when File
          ::YAML::load(::ERB.new(File.read(creds.path)).result)
        when String, Pathname
          ::YAML::load(::ERB.new(File.read(creds)).result)
        when Hash
          creds
        else
          raise ArgumentError, "Credentials are not a path, file, or hash."
        end
      end
    end
  end
end