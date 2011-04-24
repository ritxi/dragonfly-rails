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
    def create_dragonfly_uid
      if path = (avatar and avatar.path(:original))
        new_path = path[%r{\d+/.*_original.*$}]
        update_attribute(:df_avatar_uid, "/#{self.class.df_scope}/#{new_path}")
      end
    end
  end
end