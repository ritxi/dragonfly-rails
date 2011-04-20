class User < ActiveRecord::Base
  kaltha_dragonfly_for :avatar, :scope => 'avatar'
end