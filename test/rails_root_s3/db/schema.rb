ActiveRecord::Schema.define do
  create_table "users", :force => true do |t|
    t.column "name",  :text
    t.column "email", :text
    t.column "avatar_uid", :string
  end
  create_table "images", :force => true do |t|
    t.column "title",  :text
    t.column "description", :text
    t.column "image_uid", :string
  end
  create_table 'old_paperclips', :force => true do |t|
    t.string   :paperclip_uid
    t.string   :pc_paperclip_file_name
    t.string   :pc_paperclip_content_type
    t.integer  :pc_paperclip_file_size
    t.datetime :pc_paperclip_updated_at
  end
end