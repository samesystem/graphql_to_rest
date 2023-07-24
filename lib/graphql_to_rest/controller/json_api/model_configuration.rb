# frozen_string_literal: true

module GraphqlToRest
  module Controller
    module JsonApi
      # Configuration for model
      class ModelConfiguration
        def initialize(name: nil)
          @name = name
          @nested_fields = []
          @default_fields = []
        end

        def name(new_name = nil)
          return @name if new_name.nil?

          @name = new_name
          self
        end

        def initialize_copy(_source)
          super
          @nested_fields = @nested_fields.dup
        end

        def nested_fields(*fields)
          return @nested_fields if fields.empty?

          @nested_fields = join_fields(@nested_fields, fields)
          self
        end

        def default_fields(*fields)
          return @default_fields if fields.empty?

          @default_fields = join_fields(@default_fields, fields)
          self
        end

        private

        def join_fields(*lists)
          lists.flatten.map(&:to_s).uniq
        end
      end
    end
  end
end
