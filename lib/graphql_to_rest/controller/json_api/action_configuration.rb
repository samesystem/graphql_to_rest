# frozen_string_literal: true

require 'graphql_to_rest/controller/basic/action_configuration'

module GraphqlToRest
  module Controller
    module JsonApi
      # Configuration for OpenAPI controller action
      class ActionConfiguration < GraphqlToRest::Controller::Basic::ActionConfiguration
        def model
          controller_config.model
        end

        def fieldset_parameter
          @fieldset_parameter ||= begin
            name = "fields[#{controller_config.model.name}]"
            parameter = parameter_configuration_class.new(name: name)
            parameter.default_value(model.default_fields)
            parameter
          end
        end

        def serializers
          @serializers ||= begin
            require 'graphql_to_rest/schema/json_api/serializers'
            Schema::JsonApi::Serializers.new
          end
        end
      end
    end
  end
end
