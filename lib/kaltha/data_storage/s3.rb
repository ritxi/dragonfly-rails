module Dragonfly
  module DataStorage
    class S3DataStore
      include ::Kaltha::StoringScope
      def path
        %w(p)
      end
      def generate_uid(name)
        generate_path(name)
      end
    end
  end
end