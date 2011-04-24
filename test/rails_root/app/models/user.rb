class User < ActiveRecord::Base
  dragonfly_for :avatar, :scope => 'avatars'
end