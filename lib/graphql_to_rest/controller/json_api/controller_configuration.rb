# frozen_string_literal: true

require 'graphql_to_rest/controller/basic/controller_configuration'
require 'graphql_to_rest/controller/json_api/action_configuration'

module GraphqlToRest
  module Controller
    module JsonApi
      # Configuration for OpenAPI controller
      class ControllerConfiguration < GraphqlToRest::Controller::Basic::ControllerConfiguration
        def model(name = nil)
          return @model if name.nil?

          @model = name
          self
        end

        private

        def action_configuration_class
          JsonApi::ActionConfiguration
        end
      end
    end
  end
end
