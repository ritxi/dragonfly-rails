require 'dragonfly'
require 'rails'
#require 'paperclip'
#require 'paperclip_s3'
%w(active_model_extension data_storage model_extension image_magick/utils railtie version).each{|lib| require File.join %W(dragonfly_rails #{lib})}
%w(heroku).each{|lib| require File.join %W(dragonfly_rails config #{lib})}
module DragonflyRails
  mattr_accessor :security_key
  @@security_key = 'kaltha'
  
  mattr_accessor :protect_from_dos_attacks
  @@protect_from_dos_attacks = true
  
  mattr_accessor :route_path
  @@route_path = 'media' # /media/añlksdjfalñsdjfalñsdfjlñasdkfj
  
  mattr_accessor :assets_path
  @@assets_path = :default # ::Rails.root.join('public','assets')
  
  mattr_accessor :storage_options
  @@storage_options = {:storage => :filesystem}
end

