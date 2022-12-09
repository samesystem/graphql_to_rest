# frozen_string_literal: true

require 'graphql_to_rest/controller/basic/parameter_configuration'

module GraphqlToRest
  module Controller
    module Basic
      # Configuration for OpenAPI controller action
      class ActionConfiguration
        def initialize(controller_config:)
          @controller_config = controller_config
          @query_parameters = {}
          @path_parameters = {}
        end

        def parameter_configuration_class
          Basic::ParameterConfiguration
        end

        def query_parameter(name)
          @query_parameters[name.to_s] ||= build_parameter_configuration(name: name.to_s)
          param = @query_parameters[name.to_s]
          yield(param) if block_given?
          param
        end

        def path_parameter(name)
          @path_parameters[name.to_s] ||= build_parameter_configuration(name: name.to_s)
        end

        def graphql_action(name = nil)
          return @graphql_action if name.nil?

          @graphql_action = name
          self
        end

        def graphql_input_type_path(nesting = nil)
          return @graphql_input_type_path || [] if nesting.nil?

          @graphql_input_type_path = Array(nesting)
          self
        end

        private

        attr_reader :controller_config

        def build_parameter_configuration(**kwargs)
          parameter_configuration_class.new(kwargs)
        end
      end
    end
  end
end
