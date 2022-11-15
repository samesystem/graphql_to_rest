# frozen_string_literal: true

require 'graphql_to_rest/graphql_type_parser'
require 'graphql_to_rest/components/type_to_components_schemas'

module GraphqlToRest
  module Components
    # Converts GraphQL type to OpenAPI schema
    class RoutesToComponentsSchemas
      method_object %i[routes!]

      def call
        schemas.to_a.sort_by { _1.first }.to_h
      end

      private

      def components_schemas_for(route, cached_schemas)
        TypeToComponentsSchemas.call(graphql_type: route.return_type, cached_schemas: cached_schemas)
      end

      def schemas
        routes.each.reduce({}) do |cached_schemas, route|
          new_schemas = components_schemas_for(route, cached_schemas)
          cached_schemas.merge(new_schemas)
        end
      end
    end
  end
end
