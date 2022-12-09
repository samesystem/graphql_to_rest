# frozen_string_literal: true

require 'graphql_to_rest/controller/json_api/action_configuration'

module GraphqlToRest
  module Controller
    # Configuration for OpenAPI controller
    module JsonApiSimplified
      module ClassMethods
        def open_api
          @open_api ||= build_controller_configuration
          yield(@open_api) if block_given?
          @open_api
        end

        private

        def build_controller_configuration
          JsonApiSimplified::ControllerConfiguration.new
        end
      end

      def self.included(base)
        base.include(GraphqlToRest::Controller::Basic)
        base.extend(ClassMethods)
      end

      private

      def attributes_to_return
        attribute_name = open_api_action.fieldset_parameter.name
        fieldset_name ||= "fields[#{open_api.model}]" if open_api.model
        keys = fieldset_name.to_s.split(/[\[\]]/).reject(&:blank?)

        params.dig(*keys).to_s.split(',').presence || open_api_action.fieldset_parameter.default_value
      end
    end
  end
end
