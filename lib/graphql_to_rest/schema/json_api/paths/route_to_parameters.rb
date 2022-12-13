# frozen_string_literal: true

require 'graphql_to_rest/schema/basic/paths/route_to_parameters'
require_relative './route_to_fieldset_parameter'

module GraphqlToRest
  class Schema
    module JsonApi
      module Paths
        # Converts GraphQL type to OpenAPI path parameters
        class RouteToParameters < GraphqlToRest::Schema::Basic::Paths::RouteToParameters
          def call
            fieldset_parameter = route.open_api_json_for('paths.{path}.{method}.parameters:fieldset')
            [fieldset_parameter, *super]
          end
        end
      end
    end
  end
end
