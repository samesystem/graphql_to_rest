# frozen_string_literal: true

module GraphqlToRest
  module Test
    module RailsRoutesHelper
      def rails_route_double(http_method, path, controller_and_action, app: 'dummy_app_json_api')
        path_double = double('RailsRoutePth', spec: path)
        controller, action = controller_and_action.split('#')

        full_controller = "graphql_to_rest/#{app}/api/v1/#{controller}"

        double(
          'RailsRoute',
          path: path_double,
          verb: http_method,
          defaults: { controller: full_controller, action: action }
        )
      end

      def route_double(http_method, path, controller_and_action, app: 'dummy_app_json_api')
        route = rails_route_double(http_method, path, controller_and_action, app: app)

        GraphqlToRest::Paths::RouteDecorator.new(
          rails_route: route,
          graphql_schema: GraphqlToRest::DummyAppShared::Schema
        )
      end

      def route_double_for(action)
        case action
        when 'users#create'
          route_double('post', '/api/v1/users(.:format)', "users#create")
        when 'users#show'
          route_double('get', '/api/v1/users/:id', "users#show")
        else
          raise "Unknown action: #{action}"
        end
      end
    end
  end
end
