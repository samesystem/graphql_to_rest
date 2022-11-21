# frozen_string_literal: true

require 'graphql_to_rest/graphql_type_parser'

module GraphqlToRest
  module Components
    module Schemas
      # Converts GraphQL type to OpenAPI schema
      class TypeToSchemas
        method_object %i[graphql_type! cached_schemas!]

        def call
          return {} if cached_schemas.key?(open_api_type_name)
          return {} if type_parser.deeply_basic?
          return schema_for_graphql_enum if type_parser.deeply_enum?

          schemas_for_graphql_object
        end

        private

        delegate :open_api_type_name, :inner_nullable_graphql_object, to: :type_parser, private: true


        def schemas_for_graphql_object
          schema_for_graphql_object.merge(schemas_for_properties)
        end

        def schema_for_graphql_object
          {
            open_api_type_name => {
              type: 'object',
              properties: properties,
              required: required_properties.presence
            }.compact
          }
        end

        def schema_for_graphql_enum
          {
            open_api_type_name => {
              type: 'string',
              enum: inner_nullable_graphql_object.values.keys
            }
          }
        end

        def properties
          property_parsers.transform_values { _1.open_api_schema_reference }
        end

        def schemas_for_properties
          property_parsers.reduce(cached_schemas) do |property_cached_schemas, (_, property_parser)|
            newly_cached_schemas = schemas_for_property(property_parser, property_cached_schemas)
            property_cached_schemas.merge(newly_cached_schemas)
          end
        end

        def schemas_for_property(property_parser, property_cached_schemas)
          newly_cached_schemas = self.class.call(
            graphql_type: property_parser.inner_nullable_graphql_object,
            cached_schemas: property_cached_schemas
          )
        end

        def property_parsers
          unfiltered_property_parsers
            .reject { _2.deeply_object? }
            .to_a.sort_by { _1.first }.to_h
        end

        def required_properties
          property_parsers.select { |_k, v| v.required? }.keys
        end

        def type_parser
          @type_parser ||= type_parser_for(graphql_type)
        end

        def unparsed_properties
          inner_nullable_graphql_object.fields
        end

        def unfiltered_property_parsers
          @unfiltered_property_parsers ||= unparsed_properties.transform_values do |field|
            type_parser_for(field.type)
          end
        end

        def type_parser_for(type)
          GraphqlTypeParser.new(unparsed_type: type)
        end
      end
    end
  end
end
