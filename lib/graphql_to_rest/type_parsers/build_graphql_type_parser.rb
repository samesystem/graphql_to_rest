# frozen_string_literal: true

require 'graphql_to_rest/type_parsers/graphql_type_parser'

module GraphqlToRest
  module TypeParsers
    class BuildGraphqlTypeParser
      def self.call(schema_builder: nil, **kwargs)
        GraphqlTypeParser.new(**kwargs)
      end
    end
  end
end
