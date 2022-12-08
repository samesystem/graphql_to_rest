# frozen_string_literal: true

require 'graphql_to_rest/type_parsers/graphql_input_type_parser'

module GraphqlToRest
  module TypeParsers
    class BuildGraphqlInputTypeParser
      def self.call(schema_builder: nil, **kwargs)
        GraphqlInputTypeParser.new(**kwargs)
      end
    end
  end
end
