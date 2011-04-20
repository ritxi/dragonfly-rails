module DragonflyRails
  module Dragonfly
    module ActiveModelExtensions
      module ClassMethods
        def dragonfly_for(*options)
          accessor = options.first
          if options.size == 2
            options = options.last 
            set_df_scope(options[:scope]) if options[:scope]
          end
          send :include, ::DragonflyRails::CustomPathExtension
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
    class Attachment
      def initialize(model)
        @model = model
        self.uid = model_uid
        update_from_uid if uid
        @should_run_callbacks = true
        self.class.ensure_uses_cached_magic_attributes
        root_path = app.datastore.configuration[:root_path]
        app.datastore.scope_for = @model
      end
    end
  end
end