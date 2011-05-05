module Paperclip
  module Storage
    module S3
      def self.extended base
        begin
          require 'aws/s3'
        rescue LoadError => e
          e.message << " (You may need to install the aws-s3 gem)"
          raise e
        end unless defined?(AWS::S3)

        base.instance_eval do
          @s3_credentials = parse_credentials(@options[:s3_credentials])
          @bucket         = @options[:bucket]         || @s3_credentials[:bucket]
          @bucket         = @bucket.call(self) if @bucket.is_a?(Proc)
          @s3_options     = @options[:s3_options]     || {}
          @s3_permissions = @options[:s3_permissions] || :public_read
          @s3_protocol    = @options[:s3_protocol]    || (@s3_permissions == :public_read ? 'http' : 'https')
          @s3_headers     = @options[:s3_headers]     || {}
          @s3_host_alias  = @options[:s3_host_alias]
          @s3_host_alias  = @s3_host_alias.call(self) if @s3_host_alias.is_a?(Proc) # add this line to accept procs in :s3_host_lias
          unless @url.to_s.match(/^:s3.*url$/)
            @path          = @path.gsub(/:url/, @url)
            @url           = ":s3_path_url"
          end
          AWS::S3::Base.establish_connection!( @s3_options.merge(
            :access_key_id => @s3_credentials[:access_key_id],
            :secret_access_key => @s3_credentials[:secret_access_key]
          ))
        end
        Paperclip.interpolates(:s3_alias_url) do |attachment, style|
          "#{attachment.s3_protocol}://#{attachment.s3_host_alias}/#{attachment.path(style).gsub(%r{^/}, "")}"
        end unless Paperclip::Interpolations.respond_to? :s3_alias_url
        Paperclip.interpolates(:s3_path_url) do |attachment, style|
          "#{attachment.s3_protocol}://s3.amazonaws.com/#{attachment.bucket_name}/#{attachment.path(style).gsub(%r{^/}, "")}"
        end unless Paperclip::Interpolations.respond_to? :s3_path_url
        Paperclip.interpolates(:s3_domain_url) do |attachment, style|
          "#{attachment.s3_protocol}://#{attachment.bucket_name}.s3.amazonaws.com/#{attachment.path(style).gsub(%r{^/}, "")}"
        end unless Paperclip::Interpolations.respond_to? :s3_domain_url
      end
      def expiring_url(time = 3600, style_name = default_style)
        AWS::S3::S3Object.url_for(path(style_name), bucket_name, :expires_in => time, :use_ssl => (s3_protocol == 'https'))
      end
    end
  end
end