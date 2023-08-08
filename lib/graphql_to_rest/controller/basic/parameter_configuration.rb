# frozen_string_literal: true

module GraphqlToRest
  module Controller
    module Basic
      # Configuration for OpenAPI controller action parameter
      class ParameterConfiguration
        attr_reader :name

        def initialize(name:)
          @name = name
          @required = true
        end

        def required
          @required = true
          self
        end

        def optional
          @required = false
          self
        end

        def required?
          @required
        end

        def default_value(value = nil)
          return @default_value if value.nil?

          @default_value = value
          self
        end

        def graphql_input_type_path(nesting = nil)
          return @graphql_input_type_path || [] if nesting.nil?

          @graphql_input_type_path = Array(nesting)
          self
        end
      end
    end
  end
end
