module DragonflyRails
  module StoringScope
    module Tools
      def self.id_partition *options
        model_id = options.first
        ("%09d" % model_id).scan(/\d{3}/).join("/")
      end
      def self.time_partition *options
        ::File.join(Time.now.strftime('%Y/%m/%d/%H/%M/%S'), rand(1000).to_s)
      end
      def self.filename_for(file)
        file.gsub(/[^\w.]+/, '_')
      end
    end
    
    def scope_for=(model_object)
      @model = model_object
      scoped_path = @model.class.respond_to?('df_scope') && @model.class.df_scope ? @model.class.df_scope : @model.class.table_name
      @custom_scope = scoped_path
    end
    
    def custom_scope
      @custom_scope
    end
    
    def path
      raise "Path must be defined on the class where I'll be included to(File, S3, Mongo, etc)!!!!"
    end
    
    # Generate path as id_partition or time_partition
    # depending on @model.partition_style method
    def generate_path(filename)
      path_style = @model.path_style
      filename = ::DragonflyRails::StoringScope::Tools::filename_for(filename)
      uid = eval("::DragonflyRails::StoringScope::Tools::#{path_style}(@model[:id])")
      new_path =  ::File.join(custom_scope, uid, filename)
      new_path
    end
  end
end