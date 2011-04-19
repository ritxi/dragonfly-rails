module Kaltha
  module CustomPathExtension
    TO_BE_MIGRATE=true
    def partion_style
      :id_partition
    end
    def create_dragonfly_uid
      if path = (avatar and avatar.path(:original))
        new_path = path[%r{\d+/.*_original.*$}]
        update_attribute(:df_avatar_uid, "/#{df_scope}/#{new_path}")
      end
    end
  end
end