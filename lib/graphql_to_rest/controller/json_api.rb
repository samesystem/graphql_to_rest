# frozen_string_literal: true

require 'graphql_to_rest/controller/json_api/controller_configuration'
require 'graphql_to_rest/controller/json_api/fieldset_to_graphql_output'
require 'graphql_to_rest/controller/basic'

module GraphqlToRest
  module Controller
    # Configuration for OpenAPI controller
    module JsonApi
      module ClassMethods
        def open_api_configuration_class
          JsonApi::ControllerConfiguration
        end
      end

      def self.included(base)
        base.include(GraphqlToRest::Controller::Basic)
        base.extend(ClassMethods)
      end

      private

      def fieldset
        fieldset_name = open_api_action.fieldset_parameter.name
        fieldset_name ||= "fields[#{open_api.model.name}]" if open_api.model
        keys = fieldset_name.to_s.split(/[\[\]]/).reject(&:blank?)

        params.dig(*keys).to_s.split(',').presence || open_api_action.fieldset_parameter.default_value
      end

      def action_output_fields
        GraphqlToRest::Controller::JsonApi::FieldsetToGraphqlOutput.call(fieldset: fieldset)
      end
    end
  end
end
