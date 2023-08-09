# frozen_string_literal: true

require_relative '../schemas/type_to_schemas'

module GraphqlToRest
  class Schema
    module Basic
      module Components
        module RequestBodies
          # Converts GraphQL type to OpenAPI requestBodies schemas
          class TypeToSchemas < Basic::Components::Schemas::TypeToSchemas
            def call
              return {} if graphql_type.nil?

              super
            end

            private

            def unparsed_properties
              inner_nullable_graphql_object.arguments
            end

            def type_parser_for(type)
              TypeParsers::GraphqlInputTypeParser.new(unparsed_type: type)
            end
          end
        end
      end
    end
  end
end
