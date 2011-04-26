module DragonflyRails
  module Dragonfly
    module ActiveModelExtensions
      module ClassMethods
        def dragonfly_for(*options)
          
          accessor = options.first
     
          if options.size == 2
            options = options.last 
            set_df_scope(options[:scope]) if options[:scope]
            if options[:with_paperclip]
              df_uid = "#{accessor}_uid".to_sym
              paperclip_accessor = options[:with_paperclip]
              after_create lambda{ create_dragonfly_uid(df_uid, paperclip_accessor)}, :unless => df_uid
              after_update lambda{ update_dragonfly_uid(df_uid, paperclip_accessor)}, :if => lambda {changed.include?("#{paperclip_accessor}_updated_at")}
            end
          end
          send :include, ::DragonflyRails::CustomPathExtension
          df_rails_image_accessor accessor
          image_accessor accessor
        end
        def df_scope
          @scope ||= self.table_name
        end
        
        # Dragonfly scope setter
        def set_df_scope(scope)
          @scope = scope
        end
      end
    end
  end
end

module Dragonfly
  module ActiveModelExtensions
    module InstanceMethods
      private
      alias_method :original_save_dragonfly_attachments, :save_dragonfly_attachments
      def save_dragonfly_attachments
        if path_style == :time_partition && new_record?
          original_save_dragonfly_attachments
        end
        if path_style == :id_partition && !new_record?
          original_save_dragonfly_attachments
          dragonfly_attachments.each do |attribute, attachment|
            uid = "#{attribute}_uid"
            if eval("!@saved_#{uid}") and changes[uid] and changes[uid].first.nil?
              eval("@saved_#{uid} = true")
              save!
            end
          end
        end
      end
    end
    module ClassMethods
      alias_method :original_register_dragonfly_app, :register_dragonfly_app
      def register_dragonfly_app(macro_name, app)
        original_register_dragonfly_app(macro_name, app)
        (class << self; self; end).class_eval do
          # Registers the after_save callback
          define_method "df_rails_#{macro_name}" do |attribute, &config_block|
            # Add callbacks
            after_save :save_dragonfly_attachments
          end
        end
      end
    end
    class Attachment
      alias_method :original_initialize, :initialize
      def initialize(model)
        original_initialize(model)
        app.datastore.scope_for = @model
      end
    end
  end
end