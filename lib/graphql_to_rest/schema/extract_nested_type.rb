# frozen_string_literal: true

module GraphqlToRest
  class Schema
    # Extracts nested type from a given type by following given path of keys
    class ExtractNestedType
      method_object %i[type! nesting_keys!]

      def call
        nesting = nesting_keys.map(&:to_s)

        nesting.reduce(type) do |type, key|
          nested_field_type(type, key)
        end
      end

      private

      def nested_field_type(type, field)
        final_type = type.respond_to?(:unwrap) ? type.unwrap : type
        final_type = fields(final_type).fetch(field).type
        final_type = type.respond_to?(:list?) && type.list? ? final_type.to_list_type : final_type
        type.respond_to?(:non_null?) && type.non_null? ? final_type.to_non_null_type : final_type
      end

      def fields(type)
        input_type? ? type.arguments : type.fields
      end

      def input_type?
        type.respond_to?(:arguments)
      end
    end
  end
end
