# frozen_string_literal: true

require_relative './paths'
require_relative './components'

module GraphqlToRest
  class Schema
    module Basic
      class Serializers
        SERIALIZER_MAPPING = {
          'paths.{path}.{method}' => Paths::RouteToPathSchema,
          'paths.{path}.{method}.parameters' => Paths::RouteToParameters,
          'paths.{path}.{method}.responses' => Paths::GraphqlToSuccessResponse,
          'paths.{path}.{method}.requestBody' => Paths::GraphqlToPathRequestBody,
          'paths.{path}.{method}:fromFile' => Paths::RouteToPathExtras,
          'components.requestBodies' => Components::RequestBodies::TypeToSchemas,
          'components.requestBodies.properties' => Components::RequestBodies::TypeToSchemas,
          'components.schemas' => Components::Schemas::TypeToSchemas,
        }

        def serializer_for(type)
          SERIALIZER_MAPPING.fetch(type)
        end
      end
    end
  end
end
