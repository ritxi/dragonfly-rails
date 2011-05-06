module Dragonfly
  module DataStorage
    class S3DataStore
      include ::DragonflyRails::StoringScope
      alias_method :orginal_bucket_name, :bucket_name
      def bucket_name
        bname = (orginal_bucket_name.is_a?(Proc) ? orginal_bucket_name.call(@model) : self.orginal_bucket_name)
        bname
      end
      def path
        [::Rails.env.first]
      end
      def generate_uid(name)
        ::File.join(path, generate_path(name))
      end
    end
  end
end