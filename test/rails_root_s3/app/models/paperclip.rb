class OldPaperclip < ActiveRecord::Base
  dragonfly_for :paperclip, :with_paperclip => :pc_paperclip
  
  has_attached_file :pc_paperclip,
                    {:styles => {
                      :thumb => '50x50>',
                      :original => '1200x1200>'},
                    :default_style => :thumb,
                   :path => ":root_path/paperclips/:id_partition/:basename_:style.:extension",
                   :url => "/:environment/paperclips/:id_partition/:basename_:style.:extension"}
end