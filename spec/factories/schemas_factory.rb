# This will guess the User class
FactoryBot.define do
  factory :schema, class: 'GraphqlToRest::Schema' do
    transient do
      routes_params { { app: route_app } }
      route_app { :dummy_app_json_api }
    end
    tags { %w[dummy oas] }
    servers { [{ url: '/api/v1' }] }
    info do
      {
        title: 'Dummy - OpenAPI 3.0',
        contact: {
          email: 'dummyapp1-admin@example.com'
        },
        version: '1.0.0'
      }
    end
    security_schemes do
      {
        'Bearer' => {
          type: 'http',
          scheme: 'bearer',
          bearerFormat: 'JWT'
        }
      }
    end
    graphql_schema { GraphqlToRest::DummyAppShared::Schema }
    path_schemas_dir { 'spec/fixtures/apps/dummy_app_shared' }
    rails_routes { build_list(:fake_rails_route, 1, routes_params) }

    trait :basic do
      route_app { :dummy_app_basic }
      graphql_schema { GraphqlToRest::DummyAppBasic::Schema }
    end

    trait :json_api do
      route_app { :dummy_app_json_api }
      graphql_schema { GraphqlToRest::DummyAppJsonApi::Schema }
    end

    initialize_with do
      new(
        tags: tags,
        info: info,
        servers: servers,
        security_schemes: security_schemes,
        graphql_schema: graphql_schema,
        path_schemas_dir: path_schemas_dir,
        rails_routes: rails_routes
      )
    end
  end
end
