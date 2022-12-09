# frozen_string_literal: true

module GraphqlToRest
  class Schema
    # Converts routes type to components/requestBodies json
    class RoutesToComponentsRequestBodies
      method_object %i[routes!]

      def call
        schemas.to_a.sort_by(&:first).to_h
      end

      private

      def components_schemas_for(route, cached_schemas)
        route.open_api_json_for(
          'components.requestBodies',
          graphql_type: route.input_type,
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
