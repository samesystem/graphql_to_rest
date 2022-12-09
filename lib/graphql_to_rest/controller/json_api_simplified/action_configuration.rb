# frozen_string_literal: true

require 'graphql_to_rest/controller/basic/action_configuration'
require 'graphql_to_rest/controller/json_api/parameter_configuration'

module GraphqlToRest
  module Controller
    module JsonApiSimplified
      # Configuration for OpenAPI controller action
      class ActionConfiguration < GraphqlToRest::Controller::Basic::ActionConfiguration
        attr_reader :attributes_parameters

        def attributes_parameter(name)
          @attributes_parameters ||= {}
          @attributes_parameters[name.to_s] = build_parameter_configuration_class(name: name)
        end
      end
    end
  end
end
