module Dragonfly
  module ImageMagick
    module Utils
      private
      def convert(temp_object=nil, args='', format=nil)
        tempfile = new_tempfile(format)
        run "#{convert_command} #{args} '#{temp_object.path if temp_object}' '#{tempfile.path}'"
        tempfile
      end

      def raw_identify(temp_object, args='')
        run "#{identify_command} #{args} '#{temp_object.path}'"
      end
    end
  end
end