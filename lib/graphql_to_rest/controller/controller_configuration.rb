# frozen_string_literal: true

require 'graphql_to_rest/controller/action_configuration'

module GraphqlToRest
  module Controller
    # Configuration for OpenAPI controller
    class ControllerConfiguration
      def initialize
        @actions = {}
      end

      def model(name = nil)
        return @model if name.nil?

        @model = name
        self
      end

      def action_configuration_class(klass = nil)
        @action_configuration_class ||= ActionConfiguration
        return @action_configuration_class if klass.nil?

        @action_configuration_class = klass
        self
      end

      def action(name)
        @actions[name.to_sym] ||= build_action_configuration

        config = @actions[name.to_sym]
        yield(config) if block_given?
        config
      end

      private

      def build_action_configuration
        action_configuration_class.new(controller_config: self)
      end
    end
  end
end
