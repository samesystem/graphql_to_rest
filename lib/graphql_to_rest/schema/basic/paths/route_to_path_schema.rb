# frozen_string_literal: true

module GraphqlToRest
  class Schema
    module Basic
      module Paths
        # Converts rails route to path schema
        class RouteToPathSchema
          method_object %i[route!]

          def call
            specs_from_controller_config
              .deep_merge(specs_from_file)
              .deep_merge(merged_parameters_specs)
          end

          private

          delegate :http_method, :open_api_path, :action_config, :return_type,
                   :input_type, :schema_builder,
                   to: :route, private: true

          delegate :path_schemas_dir, to: :schema_builder, private: true

          def specs_from_controller_config
            @specs_from_controller_config ||= {
              open_api_path => {
                http_method.to_s => {
                  'parameters' => parameters,
                  'requestBody' => request_body,
                  'responses' => responses
                }.compact
              }
            }.deep_stringify_keys
          end

          def merged_parameters_specs
            return {} if merged_parameters.blank?

            {
              open_api_path => {
                http_method => {
                  'parameters' => merged_parameters
                }
              }
            }.deep_stringify_keys
          end

          def merged_parameters
            @merged_parameters ||= merged_grouped_parameters.values.map(&:values).flatten
          end

          def merged_grouped_parameters
            grouped_parameters(specs_from_controller_config)
              .deep_merge(grouped_parameters(specs_from_file))
          end

          def grouped_parameters(specs)
            parameters = specs.dig(open_api_path.to_s, http_method.to_s, 'parameters') || []
            parameters_by_location = parameters.group_by { |parameter| parameter['in'] }

            parameters_by_location.transform_values do |location_parameters|
              location_parameters.index_by { |parameter| parameter['name'] }
            end
          end

          def specs_from_file
            @specs_from_file ||= route.open_api_json_for(
              'paths.{path}.{method}:fromFile',
              path_schemas_dir: path_schemas_dir
            ).deep_stringify_keys
          end

          def parameters
            route.open_api_json_for('paths.{path}.{method}.parameters')
          end

          def responses
            route.open_api_json_for(
              'paths.{path}.{method}.responses',
              type: return_type
            )
          end

          def request_body
            return nil if input_type.nil?

            route.open_api_json_for(
              'paths.{path}.{method}.requestBody',
              graphql_input: input_type
            )
          end
        end
      end
    end
  end
end
