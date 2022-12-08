# This will guess the User class
FactoryBot.define do
  factory :schema, class: 'GraphqlToRest::Schema' do
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
    graphql_schema { GraphqlToRest::DummyApp1::Schema }
    path_schemas_dir { 'spec/fixtures/apps/dummy_app1' }

    initialize_with do
      new(
        tags: tags,
        info: info,
        servers: servers,
        security_schemes: security_schemes,
        graphql_schema: graphql_schema,
        path_schemas_dir: path_schemas_dir
      )
    end
  end
end
