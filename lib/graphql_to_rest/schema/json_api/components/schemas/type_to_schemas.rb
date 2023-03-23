# frozen_string_literal: true

require 'graphql_to_rest/schema/basic/components/schemas/type_to_schemas'

module GraphqlToRest
  class Schema
    module JsonApi
      module Components
        module Schemas
          # Converts GraphQL type to OpenAPI schema
          class TypeToSchemas < GraphqlToRest::Schema::Basic::Components::Schemas::TypeToSchemas
            private

            delegate :action_config, to: :route, private: true
            delegate :fieldset_parameter, to: :action_config, private: true

            def allowed_property?(property_name, property_parser)
              super || referenced_graphql_names.include?(property_parser.graphql_name)
            end

            private

            def referenced_graphql_names
              @referenced_graphql_names ||= route.schema_builder.referenced_graphql_names
            end
          end
        end
      end
    end
  end
end
