module DragonflyRails
  module StoringScope
    module Tools
      def id_partition *options
        model_id = options.first
        ("%09d" % model_id).scan(/\d{3}/).join("/")
      end
      def time_partition *options
        ::File.join(Time.now.strftime('%Y/%m/%d/%H/%M/%S'), rand(1000))
      end
      def filename_for(file)
        file.gsub(/[^\w.]+/, '_')
      end
    end
    
    def scope_for=(model_object)
      @model = model_object
      @custom_scope = ::File.join(path, ((@model.class.respond_to?('df_scope') && @model.class.df_scope) ? @model.class.df_scope : @model.class.table_name))
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
      filename = Tools::filename_for(filename)
      uid = send("Tools::#{path_style}", @model[:id])
      new_path =  ::File.join(custom_scope, uid, filename)
      puts "Generated path: #{new_path}"
      new_path
    end
  end
end