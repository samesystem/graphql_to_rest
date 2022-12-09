# frozen_string_literal: true

require 'graphql_to_rest/schema/basic/concerns/properties_parseable'

module GraphqlToRest
  class Schema
    module JsonApi
      module Paths
        # Converts GraphQL type to OpenAPI schema
        class RouteToFieldsetEnumSchema
          include Basic::PropertiesParseable

          method_object [:route!]

          def call
            {
              type: 'string',
              enum: enums
            }.compact
          end

          private

          delegate :action_config, to: :route
          delegate :open_api_type_name, to: :type_parser, private: true

          def enums
            [*non_object_enums, *config_enums].uniq.sort
          end

          def non_object_enums
            property_parsers.keys
          end

          def allowed_property?(property_name, property_parser)
            !property_parser.deeply_object?
          end

          def config_enums
            action_config.fieldset_parameter&.nested_fields || []
          end

          def type_parser
            @type_parser ||= TypeParsers::GraphqlTypeParser.new(unparsed_type: route.return_type)
          end
        end
      end
    end
  end
end
