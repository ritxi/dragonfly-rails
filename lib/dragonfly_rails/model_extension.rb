module DragonflyRails
  module CustomPathExtension
    TO_BE_MIGRATE=true
    PATH_STYLES = [:id_partition, :time_partition]
    def path_style=(style)
      raise "Unknown path_style: #{style}" unless PATH_STYLES.include?(style)
      @path_style = style
    end
    def path_style
      @path_style ||= :id_partition
    end
    def create_dragonfly_uid(df_uid_field,paperclip_accessor, options = {})
      path = new_dagronfly_path(df_uid_field,paperclip_accessor, options)
      if send(df_uid_field).nil? && path
        update_attribute(df_uid_field, generate_path(path))
      end
    end
    def update_dragonfly_uid(df_uid_field,paperclip_accessor, options = {})
      current_path = send(df_uid_field)
      path = new_dagronfly_path(df_uid_field,paperclip_accessor, options)
      update_attribute(df_uid_field, generate_path(path)) if generate_path(path) != current_path
    end
    def new_dagronfly_path(df_uid_field,paperclip_accessor, options = {})
      options = {:original_size => :original}.merge(options)
      send(paperclip_accessor).path(options[:original_size])
    end
    def generate_path(path)
      ::File.join(Rails.env.first.to_s, path[%r{\w{1,}\/(\d{3}\/){3}.*}])
    end
  end
end