# frozen_string_literal: true

require 'graphql_to_rest/controller/basic/action_configuration'
require 'graphql_to_rest/controller/json_api/parameter_configuration'

module GraphqlToRest
  module Controller
    module JsonApi
      # Configuration for OpenAPI controller action
      class ActionConfiguration < GraphqlToRest::Controller::Basic::ActionConfiguration
        def parameter_configuration_class
          JsonApi::ParameterConfiguration
        end

        def fieldset_parameter
          @fieldset_parameter ||=
            build_parameter_configuration(name: "fields[#{controller_config.model}]")
        end
      end
    end
  end
end
