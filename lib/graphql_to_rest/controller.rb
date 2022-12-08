# frozen_string_literal: true

require 'graphql_to_rest/controller/controller_configuration'

module GraphqlToRest
  # Contains configuration
  module Controller
    # Configuration for a controller action
    module ClassMethods
      def open_api
        @open_api ||= build_controller_configuration
        yield(@open_api) if block_given?
        @open_api
      end

      private

      def build_controller_configuration
        ControllerConfiguration.new
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

    def fieldset
      fieldset_name = open_api_action.fieldset_parameter.name
      fieldset_name ||= "fields[#{open_api.model}]" if open_api.model
      keys = fieldset_name.to_s.split(/[\[\]]/).reject(&:blank?)

      params.dig(*keys).to_s.split(',').presence || open_api_action.fieldset_parameter.default_value
    end

    def open_api
      self.class.open_api
    end

    def open_api_action
      open_api.action(action_name)
    end
  end
end
