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
      alias_method :original_initialize, :initialize
      def initialize(model)
        original_initialize(model)
        app.datastore.scope_for = @model
      end
    end
  end
end