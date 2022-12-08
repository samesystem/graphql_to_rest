# frozen_string_literal: true

require 'graphql_to_rest/components/schemas/type_to_schemas'

module GraphqlToRest
  module Components
    module Schemas
      # Converts routes type to components/schemas json
      class RoutesToSchemas
        method_object %i[routes! schema_builder!]

        def call
          schemas.to_a.sort_by { _1.first }.to_h
        end

        private

        def components_schemas_for(route, cached_schemas)
          schema_builder.call_service(
            Schemas::TypeToSchemas,
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
end
