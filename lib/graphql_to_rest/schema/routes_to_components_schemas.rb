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
        action_components_schemas(route, cached_schemas)
          .merge(parameters_component_schemas(route, cached_schemas))
      end

      def action_components_schemas(route, cached_schemas)
        route.open_api_json_for(
          'components.schemas',
          graphql_type: route.return_type,
          cached_schemas: cached_schemas
        )
      end

      def parameters_component_schemas(route, cached_schemas)
        route.action_config.query_parameters.values.reduce({}) do |schemas, parameter|
          schemas.merge(
            route.open_api_json_for(
              'components.schemas:requestBodies',
              graphql_type: parameter_graphql_input_type(route, parameter),
              cached_schemas: cached_schemas
            )
          )
        end
      end

      def schemas
        routes.each.reduce({}) do |cached_schemas, route|
          new_schemas = components_schemas_for(route, cached_schemas)
          cached_schemas.merge(new_schemas)
        end
      end

      def parameter_graphql_input_type(route, parameter)
        return nil if parameter.graphql_input_type_path.empty?

        route.input_type_for(parameter)
      end
    end
  end
end
