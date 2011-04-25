# About dragonfly-rails

It's a rail engine that loads dragonfly gem adding scope and id_partion storing style. It let paperclip users to migrate to this solution when require more image size flexibility without loosing this file storing structure.

Dragonfly store files using the current time, but for paperclip you can make Dragonfly to save files at /:dragonfly_scope/:id_partition

class User < ActiveRecord::Base
  dragonfly_for :avatar_file, :scope => 'avatars'
end

User avatar files will be stored as /avatars/000/000/001/filename_original.jpg

class Image < ActiveRecord::Base
  dragonfly_for :file # scope defaults to 'images'
end

Image files will be stored as /images/000/000/001/filename_original.jpg


# Basic configuration

## Rails Gemfile dependencies

gem 'dragonfly'
gem 'dragonfly-rails', :require => 'dragonfly_rails', :git => 'https://github.com/ritxi/dragonfly-rails.git'

## App configuration (config/application.rb)

config.dragonfly_rails.security_key = 'mysecretkey'
config.dragonfly_rails.protect_from_dos_attacks = true
config.dragonfly_rails.route_path = 'media' # /media

\# Default is Rails.root.join('public','assets'), this will only be used on local development environment, I expect production to use amazon and heroku
config.dragonfly_rails.assets_path = 'local/path/where/assets/should/be/stored'

## Model setup

### Default Images scope is good for you?

class Image < ActiveRecord::Base
  dragonfly_for :file # scope defaults to 'images'
end

\# Add the following migration to your images migration file or add a new migration adding the file_uid field
create_table "images", :force => true do |t|
  ...
  t.column "file_uid", :string
end

### Prefere custom scope?

\# Add the following migration to your images migration file or add a new migration adding the avatar_file_uid field
class User < ActiveRecord::Base
  dragonfly_for :avatar_file, :scope => 'avatars'
end

create_table "users", :force => true do |t|
  ...
  t.column "avatar_file_uid", :string
end

## Paperclip migration

Create a rake task

User.each do |u|
  u.create_dragonfly_uid(:avatar_file_uid, :paper_clip_accessor, :original_size => :original)
end