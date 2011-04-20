ActiveRecord::Schema.define do
  create_table "users", :force => true do |t|
    t.column "name",  :text
    t.column "email", :text
    t.column "avatar_uid", :integer
  end
  create_table "images", :force => true do |t|
    t.column "title",  :text
    t.column "description", :text
    t.column "image_uid", :integer
  end
end