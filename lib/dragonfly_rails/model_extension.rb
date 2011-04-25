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
      options = {:original_size => :original}.merge(options)
      path = send(paperclip_accessor).path(options[:original_size])
      if send(df_uid_field).nil? && path
        new_path = path[%r{\w{1,}\/(\d{3}\/){3}.*}]
        update_attribute(df_uid_field, new_path)
      end
    end
  end
end