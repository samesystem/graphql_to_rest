# frozen_string_literal: true

module GraphqlToRest
  module Controller
    module JsonApi
      # Configuration for OpenAPI controller action parameter
      class FieldsetParameterConfiguration < GraphqlToRest::Controller::Basic::ParameterConfiguration
        def nested_fields(fields = nil, *extra_fields)
          @nested_fields ||= []
          return @nested_fields if fields.nil?

          @nested_fields = [*@nested_fields, *fields, *extra_fields].uniq
          self
        end
      end
    end
  end
end
