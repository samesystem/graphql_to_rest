# frozen_string_literal: true

require 'graphql_to_rest/type_parsers/graphql_type_parser'

module GraphqlToRest
  class Schema
    module Basic
      # Adds methods for parsing properties.
      # Expects #type_parser and #allowed_property? to be defined.
      module PropertiesParseable
        private

        def inner_nullable_graphql_object
          @inner_nullable_graphql_object ||= type_parser.inner_nullable_graphql_object
        end

        def property_parsers
          unfiltered_property_parsers
            .select { |name, parser| allowed_property?(name, parser) }
            .to_a.sort_by(&:first).to_h
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
          TypeParsers::GraphqlTypeParser.new(unparsed_type: type)
        end
      end
    end
  end
end
