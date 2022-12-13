# frozen_string_literal: true

require 'graphql_to_rest/schema/basic/components/schemas/type_to_schemas'

module GraphqlToRest
  class Schema
    # Converts routes type to components/schemas json
    class RoutesToComponentsSchemas
      method_object %i[routes!]

      def call
        schemas.to_a.sort_by(&:first).to_h
      end

      private

      def components_schemas_for(route, cached_schemas)
        route.open_api_json_for(
          'components.schemas',
          graphql_type: route.return_type,
          cached_schemas: cached_schemas
        )
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
