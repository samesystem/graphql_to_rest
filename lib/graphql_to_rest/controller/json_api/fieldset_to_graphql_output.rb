module GraphqlToRest
  module Controller
    module JsonApi
      class FieldsetToGraphqlOutput
        method_object %i[fieldset]

        def call
          intermediate = fieldset.each_with_object({}) do |string_path, obj|
            path = string_path.to_s.split('.').map(&:to_sym)

            accumulate(obj, path)
          end

          compact(intermediate)
        end

        private

        def accumulate(obj, path)
          key, *next_path = path

          obj[key] = {} unless obj.key?(key)

          return if next_path.empty?

          accumulate(obj[key], next_path)
        end

        def compact(obj)
          array = []
          nested = {}

          obj.each do |key, value|
            next array.push(key) if value.empty?

            nested[key] = compact(value)
          end

          array.push(nested) unless nested.empty?

          array
        end
      end
    end
  end
end
