# frozen_string_literal: true

require 'graphql_to_rest/schema/basic/serializers'
require_relative './paths'
require_relative './components'

module GraphqlToRest
  class Schema
    module JsonApi
      class Serializers < Basic::Serializers
        SERIALIZER_MAPPING = {
          'components.schemas' => Components::Schemas::TypeToSchemas,
          'paths.{path}.{method}.parameters' => JsonApi::Paths::RouteToParameters,
          'paths.{path}.{method}.parameters:fieldset' => Paths::RouteToFieldsetParameter,
          'paths.{path}.{method}.parameters.items:fieldset' => Paths::RouteToFieldsetEnumSchema
        }

        def serializer_for(key)
          SERIALIZER_MAPPING.fetch(key) { super }
        end
      end
    end
  end
end
