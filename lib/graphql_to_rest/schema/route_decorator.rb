# frozen_string_literal: true

module GraphqlToRest
  class Schema
    # Adds handy OpenAPI methods on top of rails route
    class RouteDecorator
      PATH_PARAM_REGEXP = %r{:[^/]+}.freeze

      delegate :graphql_schema, to: :schema_builder
      attr_reader :schema_builder

      def initialize(rails_route:, schema_builder:)
        @rails_route = rails_route
        @schema_builder = schema_builder
      end

      def input_type
        return nil if action_config.graphql_input_type_path.empty?

        nesting_keys = action_config.graphql_input_type_path.map(&:to_s)
        graphql_schema_action.arguments[*nesting_keys].type
      end

      def return_type
        graphql_schema_action.type
      end

      def action_config
        return @action_config if defined?(@action_config)

        @action_config = controller_config.action(action_name)
      end

      def controller_config
        controller_class.try(:open_api)
      end

      def http_method
        rails_route.verb.downcase
      end

      def open_api_path
        @open_api_path ||= path_parameters.reduce(route_path) do |path, param|
          path.sub(":#{param}", "{#{param}}")
        end
      end

      def path_parameters
        @path_parameters ||= route_path.scan(PATH_PARAM_REGEXP).map { _1.sub(':', '') }
      end

      def action_name
        return @action_name if defined?(@action_name)

        @action_name = rails_route.defaults[:action]
      end

      def controller_class
        return @controller_class if defined?(@controller_class)

        controller_name = "#{rails_route.defaults[:controller]}_controller"
        @controller_class = "::#{controller_name.classify}".safe_constantize
      end

      def open_api_json_for(type, **kwargs)
        action_serializers.serializer_for(type).call(route: self, **kwargs)
      end

      def description
        graphql_schema_action.description
      end

      private

      attr_reader :rails_route

      def action_serializers
        action_config.serializers
      end

      def graphql_schema_action
        (queries[graphql_action] || mutations[graphql_action])
      end

      def route_path
        @route_path ||= begin
          rails_path = rails_route.path.spec.to_s
          rails_path.sub(%r{^/api/v\d+}, '').sub('(.:format)', '')
        end
      end

      def mutations
        @mutations ||= graphql_schema.mutation.fields
      end

      def queries
        @queries ||= graphql_schema.query.fields
      end

      def graphql_action
        @graphql_action ||= action_config.graphql_action.to_s
      end
    end
  end
end
