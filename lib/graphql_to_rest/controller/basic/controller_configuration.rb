# frozen_string_literal: true

require 'graphql_to_rest/controller/basic/action_configuration'

module GraphqlToRest
  module Controller
    module Basic
      # Configuration for OpenAPI controller
      class ControllerConfiguration
        def initialize
          @actions = {}
        end

        def initialize_copy(other)
          super
          @actions = other.instance_variable_get(:@actions).transform_values(&:dup)
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

        def action_configuration_class
          ActionConfiguration
        end
      end
    end
  end
end
