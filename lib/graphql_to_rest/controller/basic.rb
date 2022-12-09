# frozen_string_literal: true

require 'graphql_to_rest/controller/json_api/action_configuration'

module GraphqlToRest
  module Controller
    # Configuration for OpenAPI controller
    module Basic
      module ClassMethods
        def open_api
          @open_api ||= build_controller_configuration
          yield(@open_api) if block_given?
          @open_api
        end

        def open_api_configuration_class
          Basic::ControllerConfiguration
        end

        private

        def build_controller_configuration
          open_api_configuration_class.new
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
      end

      private

      def graphql_action_name
        open_api_action.graphql_action
      end

      def action_input_fields
        fields = params.dig(:data, :attributes).to_h.symbolize_keys
        if open_api_action.graphql_input_type_path.present?
          {}.set(*open_api_action.graphql_input_type_path, fields)
        else
          fields
        end
      end

      def open_api
        self.class.open_api
      end

      def open_api_action
        open_api.action(action_name)
      end
    end
  end
end
