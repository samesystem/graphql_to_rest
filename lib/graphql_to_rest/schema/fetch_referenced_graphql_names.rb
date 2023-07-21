# frozen_string_literal: true

module GraphqlToRest
  class Schema
    # Fetches referenced GraphQL names
    class FetchReferencedGraphqlNames
      method_object %i[route!]

      def call
        types = [return_type_parser.graphql_name] + nested_graphql_names
        types.flatten.uniq
      end

      private

      def return_type_parser
        @return_type_parser ||= build_type_parser(route.return_type)
      end

      def nested_graphql_names
        route.action_config.model.nested_fields.map do |compound_field|
          nested_field_graphql_references(route.return_type, compound_field)
        end
      end

      def nested_field_graphql_references(parent_type, compound_field)
        return [] if compound_field.blank?

        field, rest_fields = shift_field(compound_field)
        unwrapped_parent = build_type_parser(parent_type).inner_nullable_graphql_object
        type = unwrapped_parent.fields[field].type
        parser = build_type_parser(type)

        return [] unless parser.deeply_object?

        [parser.graphql_name] + nested_field_graphql_references(type, rest_fields)
      end

      def shift_field(compound_field)
        fields = compound_field.split('.')
        field = fields.shift
        rest_fields = fields.join('.')
        [field, rest_fields]
      end

      def build_type_parser(unparsed_type)
        GraphqlToRest::TypeParsers::GraphqlTypeParser.new(
          unparsed_type: unparsed_type
        )
      end
    end
  end
end
