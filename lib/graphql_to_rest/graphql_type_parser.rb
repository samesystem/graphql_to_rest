# frozen_string_literal: true

module GraphqlToRest
  # Converts GraphQL type to OpenAPI schema
  class GraphqlTypeParser
    BASIC_TYPE_MAPPING = {
      'id' => { type: 'string' },
      'string' => { type: 'string' },
      'text' => { type: 'string' },
      'integer' => { type: 'integer', format: 'int64' },
      'int' => { type: 'integer', format: 'int64' },
      'boolean' => { type: 'boolean' },
      'float' => { type: 'number', format: 'float' },
      'decimal' => { type: 'number', format: 'double' },
      'iso8601date' => { type: 'string', format: 'date' },
      'date' => { type: 'string', format: 'date' },
      'datetime' => { type: 'string', format: 'date-time' },
      'time' => { type: 'string', format: 'time' }
    }.freeze

    rattr_initialize %i[unparsed_type!]

    def open_api_type_name
      basic_type_name || graphql_name
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
      basic_type_schema || schema_reference
    end

    private

    delegate :graphql_name, to: :inner_nullable_graphql_object

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
      if unwraped_type.is_a?(GraphQL::Schema::Wrapper)
        unwrap_type(unwraped_type.of_type)
      else
        unwraped_type
      end
    end
  end
end
