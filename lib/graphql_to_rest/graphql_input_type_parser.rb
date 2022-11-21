# frozen_string_literal: true

require 'graphql_to_rest/graphql_type_parser'

module GraphqlToRest
  # Converts GraphQL type to OpenAPI schema
  class GraphqlInputTypeParser < GraphqlTypeParser
    rattr_initialize %i[unparsed_type!]

    private

    def schema_reference
      return super unless inner_nullable_graphql_object < GraphQL::Schema::InputObject

      { '$ref' => "#/components/requestBodies/#{open_api_type_name}" }
    end
  end
end
