# frozen_string_literal: true

require 'graphql_to_rest/type_parsers/graphql_type_parser'

module GraphqlToRest
  class Schema
    module Basic
      # Adds methods for parsing properties.
      # Expects #type_parser to be defined.
      module PropertyAllowable
        private

        def allowed_property?(property_name, property_parser)
          return true unless property_parser.deeply_object?

          allowed_fields = fieldset_parameter&.nested_fields || []
          return false if allowed_fields.empty?

          path = property_path(property_name)
          allowed_fields.any? { |field| field == path || field.start_with?("#{path}.") }
        end
      end
    end
  end
end
