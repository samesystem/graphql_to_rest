# frozen_string_literal: true

require 'graphql_to_rest/controller/basic/controller_configuration'
require 'graphql_to_rest/controller/json_api/action_configuration'

module GraphqlToRest
  module Controller
    module JsonAPI
      # Configuration for OpenAPI controller
      class ControllerConfiguration < GraphqlToRest::Controller::Basic::ControllerConfiguration
        private

        def action_configuration_class
          JsonApiSimplified::ActionConfiguration
        end
      end
    end
  end
end
