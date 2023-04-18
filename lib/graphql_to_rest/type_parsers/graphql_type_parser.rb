# frozen_string_literal: true

module GraphqlToRest
  module TypeParsers
    # Converts GraphQL type to OpenAPI schema
    class GraphqlTypeParser
      BASIC_TYPE_MAPPING = {
        'boolean' => { type: 'boolean' },
        'date' => { type: 'string', format: 'date' },
        'datetime' => { type: 'string', format: 'date-time' },
        'decimal' => { type: 'number', format: 'double' },
        'float' => { type: 'number', format: 'float' },
        'id' => { type: 'string' },
        'int' => { type: 'integer', format: 'int64' },
        'integer' => { type: 'integer', format: 'int64' },
        'iso8601datetime' => { type: 'string', format: 'date-time' },
        'iso8601date' => { type: 'string', format: 'date' },
        'json' => { type: 'object', additionalProperties: true },
        'string' => { type: 'string' },
        'text' => { type: 'string' },
        'time' => { type: 'string', format: 'time' }
      }.freeze

      rattr_initialize %i[unparsed_type!]

      def open_api_type_name
        (basic_type_name || graphql_name)
      end

      def inner_nullable_graphql_object
        unwrap_type(unparsed_type)
      end

      def deeply_scalar?
        inner_nullable_graphql_object < GraphQL::Schema::Scalar
      end

      def deeply_object?
        inner_nullable_graphql_object < GraphQL::Schema::Object
      end

      def deeply_enum?
        inner_nullable_graphql_object < GraphQL::Schema::Enum
      end

      def deeply_basic?
        basic_type_schema.present?
      end

      def required?
        unparsed_type.non_null?
      end

      def open_api_schema_reference
        if list?
          {
            type: 'array',
            items: inner_open_api_schema_reference
          }
        else
          inner_open_api_schema_reference
        end
      end

      def list?
        unparsed_type.list?
      end

      private

      delegate :graphql_name, to: :inner_nullable_graphql_object

      def inner_open_api_schema_reference
        basic_type_schema || schema_reference
      end

      def schema_reference
        { '$ref' => "#/components/schemas/#{open_api_type_name}" }
      end

      def basic_type_schema
        BASIC_TYPE_MAPPING[graphql_name.downcase]
      end

      def basic_type_name
        graphql_name.downcase if basic_type_schema
      end

      def unwrap_type(unwraped_type)
        if unwraped_type.is_a?(Class) && unwraped_type < GraphQL::Types::Relay::BaseConnection
          unwrap_type(unwraped_type.node_type)
        elsif unwraped_type.is_a?(GraphQL::Schema::Wrapper)
          unwrap_type(unwraped_type.of_type)
        else
          unwraped_type
        end
      end
    end
  end
end
