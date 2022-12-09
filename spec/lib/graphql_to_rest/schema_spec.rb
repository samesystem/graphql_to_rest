# frozen_string_literal: true

RSpec.describe GraphqlToRest::Schema do
  subject(:schema) do
    described_class.new(
      tags: tags,
      info: info,
      servers: servers,
      security_schemes: security_schemes,
      graphql_schema: graphql_schema,
      path_schemas_dir: path_schemas_dir
    )
  end

  let(:security_schemes) do
    {
      'Bearer' => {
        type: 'http',
        scheme: 'bearer',
        bearerFormat: 'JWT'
      }
    }
  end

  let(:servers) { [{ url: '/api/v1' }] }

  let(:info) do
    {

      title: 'Dummy - OpenAPI 3.0',
      contact: {
        email: 'dummyapp1-admin@example.com'
      },
      version: '1.0.0'
    }
  end

  let(:tags) { %w[dummy oas] }

  let(:all_rails_routes) do
    [
      rails_route_double(:post, '/api/v1/users(.:format)', 'users#create')
    ]
  end

  let(:graphql_schema) { GraphqlToRest::DummyAppShared::Schema }
  let(:dummy_app_path) { 'spec/fixtures/apps/dummy_app_json_api' }
  let(:path_schemas_dir) { "spec/fixtures/apps/dummy_app_shared/app/open_api/paths" }

  before do
    allow(schema).to receive(:all_rails_routes).and_return(all_rails_routes)
  end

  describe '#as_json' do
    let(:openapi_json_path) { "#{dummy_app_path}/public/openapi.json" }
    let(:dumped_json) do
      json = File.read(openapi_json_path)
      JSON.parse(json).deep_symbolize_keys
    end

    it 'matches dumped json' do
      # if you need to update saved_schema, run:
        File.write(openapi_json_path, JSON.pretty_generate(schema.as_json))
      expect(schema.as_json.deep_symbolize_keys).to eq(dumped_json)
    end
  end
end
