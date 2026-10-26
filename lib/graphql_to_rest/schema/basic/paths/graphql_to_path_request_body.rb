# frozen_string_literal: true

require 'graphql_to_rest/type_parsers/graphql_input_type_parser'

module GraphqlToRest
  class Schema
    module Basic
      module Paths
        # Converts GraphQL type to request body used in OpenAPI paths part
        class GraphqlToPathRequestBody
          method_object [:graphql_input!, :route!, { extra_specs: {} }]

          def call
            {
              'content' => {
                'application/json' => {
                  'schema' => request_body_schema,
                  **extra_specs
                }
              }
            }
          end

          private

          delegate :open_api_schema_reference, to: :type_parser, private: true

          def input_object
            type_parser.inner_nullable_graphql_object
          end

          def request_body_schema
            {
              type: 'object',
              properties: request_body_data_properties,
              required: %w[data]
            }
          end

          def request_body_data_properties
            {
              data: {
                type: 'object',
                properties: {
                  attributes: open_api_schema_reference
                },
                required: %w[attributes]
              }
            }
          end

          def type_parser
            @type_parser ||= TypeParsers::GraphqlInputTypeParser.new(unparsed_type: graphql_input)
          end
        end
      end
    end
  end
end
