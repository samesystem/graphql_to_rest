# frozen_string_literal: true

require 'rails'
require 'erb'

module GraphqlToRest
  class Schema
    module Basic
      module Paths
        # Converts rails route to path schema
        class RouteToPathExtras
          # Loads YAML file with erb support
          class YamlLoader
            attr_reader :action

            def initialize(file_path, action:)
              @file_path = file_path
              @action = action
            end

            def load
              yaml_text = ERB.new(file_content).result(binding)
              YAML.safe_load(yaml_text)
            end

            private

            attr_reader :file_path

            def file_content
              File.read(file_path.to_s)
            end
          end

          method_object %i[route! path_schemas_dir!]

          def call
            return {} unless File.exist?(file_path)

            {
              open_api_path => {
                http_method => action_specs
              }
            }
          end

          private

          delegate :http_method, :open_api_path, :action_config, :action_name, to: :route, private: true

          def action_specs
            actions_specs[action_name.to_s] || {}
          end

          def actions_specs
            @actions_specs ||= YamlLoader.new(file_path, action: action_config).load
          end

          def file_path
            Pathname.new(path_schemas_dir.to_s).join("#{route.controller_class.name.underscore}.yml")
          end
        end
      end
    end
  end
end
