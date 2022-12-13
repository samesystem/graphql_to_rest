# frozen_string_literal: true

require 'graphql_to_rest/controller/basic/action_configuration'
require_relative 'fieldset_parameter_configuration'

module GraphqlToRest
  module Controller
    module JsonApi
      # Configuration for OpenAPI controller action
      class ActionConfiguration < GraphqlToRest::Controller::Basic::ActionConfiguration
        def fieldset_parameter
          @fieldset_parameter ||=
            JsonApi::FieldsetParameterConfiguration.new(name: "fields[#{controller_config.model}]")
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
