# frozen_string_literal: true

require 'graphql_to_rest/components/schemas/type_to_schemas'

module GraphqlToRest
  module Components
    module RequestBodies
      # Converts GraphQL type to OpenAPI requestBodies schemas
      class TypeToSchemas < GraphqlToRest::Components::Schemas::TypeToSchemas
        def call
          return {} if graphql_type.nil?

          super
        end

        private

        def schema_for_graphql_enum
          {}
        end

        def unparsed_properties
          inner_nullable_graphql_object.arguments
        end

        def type_parser_for(type)
          schema_builder.call_service(TypeParsers::BuildGraphqlInputTypeParser, unparsed_type: type)
        end
      end
    end
  end
end
