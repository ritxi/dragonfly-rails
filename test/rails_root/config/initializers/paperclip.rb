Paperclip.interpolates :environment do |attachment, style|
  Rails.env.development? ? "assets" : Rails.env.first
end

Paperclip.interpolates :root_path do |attachment, style|
  dir = if Rails.env.development?
    ":rails_root/public/assets"
  elsif Rails.env.test?
    ':rails_root/tmp/test'
  else
    ':environment'
  end
end

Paperclip.interpolates :site_current_theme do |attachment, style|
  attachment.instance.site.current_theme
end

Paperclip::Attachment.default_options[:convert_options] = { :all => '-strip -colorspace RGB -resample 72'}