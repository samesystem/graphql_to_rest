# frozen_string_literal: true

require 'graphql_to_rest/type_parsers/graphql_type_parser'
require_relative '../../concerns/properties_parseable'

module GraphqlToRest
  class Schema
    module Basic
      module Components
        module Schemas
          # Converts GraphQL type to OpenAPI schema
          class TypeToSchemas
            include Basic::PropertiesParseable

            method_object %i[graphql_type! cached_schemas! route!]

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
              @schema_for_graphql_object ||= {
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
              property_parsers.transform_values(&:open_api_schema_reference)
            end

            def schemas_for_properties
              initial_cache = cached_schemas.merge(schema_for_graphql_object)
              property_parsers.reduce(initial_cache) do |property_cached_schemas, (property_name, property_parser)|
                newly_cached_schemas = schemas_for_property(property_name, property_parser, property_cached_schemas)
                property_cached_schemas.merge(newly_cached_schemas)
              end
            end

            def schemas_for_property(_property_name, property_parser, property_cached_schemas)
              self.class.call(
                graphql_type: property_parser.inner_nullable_graphql_object,
                cached_schemas: property_cached_schemas,
                route: route
              )
            end

            def allowed_property?(_property_name, property_parser)
              !property_parser.deeply_object?
            end

            def required_properties
              property_parsers.select { |_k, v| v.required? }.keys
            end

            def type_parser
              @type_parser ||= type_parser_for(graphql_type)
            end

            def type_parser_for(type)
              TypeParsers::GraphqlTypeParser.new(
                unparsed_type: type,
                unwrap_connection: false
              )
            end
          end
        end
      end
    end
  end
end
