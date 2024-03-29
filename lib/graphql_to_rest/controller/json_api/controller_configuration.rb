# frozen_string_literal: true

require 'graphql_to_rest/controller/basic/controller_configuration'
require_relative './action_configuration'
require_relative './model_configuration'

module GraphqlToRest
  module Controller
    module JsonApi
      # Configuration for OpenAPI controller
      class ControllerConfiguration < GraphqlToRest::Controller::Basic::ControllerConfiguration
        def model(name = nil)
          @model ||= ModelConfiguration.new(name: name)
          yield(@model) if block_given?
          @model
        end

        private

        def action_configuration_class
          JsonApi::ActionConfiguration
        end
      end
    end
  end
end
