# frozen_string_literal: true

module GraphqlToRest
  class Schema
    module Basic
      module Paths
        # Converts GraphQL type to OpenAPI path parameters
        class RouteToParameters
          OBJECT_QUERY_PARAMETER_PARAMS = {
            style: 'deepObject',
            explode: true
          }.freeze

          method_object %i[route!]

          def call
            parameters = path_parameters + query_parameters
            parameters.map { |parameter_schema| sorted_hash(parameter_schema) }
          end

          private

          delegate :action_config, :return_type, to: :route, private: true

          def path_parameters
            route.path_parameters.sort.map do |parameter_name|
              path_parameter_schema(parameter_name)
            end
          end

          def query_parameters
            action_config.query_parameters.values.sort_by(&:name).map do |parameter|
              query_parameter_schema(parameter)
            end
          end

          def query_parameter_schema(parameter)
            type_parser = parameter_type_parser(parameter)
            extra_params = type_parser.deeply_input_object? ? OBJECT_QUERY_PARAMETER_PARAMS : {}

            {
              **parameter_schema(parameter),
              **extra_params,
              in: 'query',
              allowReserved: true
            }
          end

          def path_parameter_schema(parameter_name)
            parameter = action_config.path_parameter(parameter_name)

            {
              **parameter_schema(parameter),
              in: 'path'
            }
          end

          def parameter_schema(parameter)
            schema = {
              name: parameter.name,
              required: parameter.required?,
              schema: parameter_type_parser(parameter).open_api_schema_reference,
            }
            schema[:default] = parameter.default_value if parameter.default_value
            schema
          end

          def parameter_type_parser(parameter)
            unparsed_type = route.input_type_for(parameter) || GraphQL::Types::String
            GraphqlToRest::TypeParsers::GraphqlInputTypeParser.new(
              unparsed_type: unparsed_type
            )
          end

          def sorted_hash(hash)
            hash.sort_by { |k, _| k.to_s }.to_h
          end
        end
      end
    end
  end
end
