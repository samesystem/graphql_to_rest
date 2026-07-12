# frozen_string_literal: true

RSpec.describe GraphqlToRest::Schema do
  subject(:schema) do
    build(:schema, :json_api)
  end

  describe '#as_json' do
    subject(:schema) { build(:schema, schema_type) }

    let(:schema_type) { :json_api }
    let(:openapi_json_path) { "spec/fixtures/apps/dummy_app_#{schema_type}/public/openapi.json" }
    let(:dumped_json) do
      json = File.read(openapi_json_path)
      JSON.parse(json).deep_symbolize_keys
    end

    context 'when schema is "json_api"' do
      let(:schema_type) { :json_api }

      it 'matches dumped json' do
        # if you need to update saved_schema, run:
          # File.write(openapi_json_path, JSON.pretty_generate(schema.as_json))
        expect(schema.as_json.deep_symbolize_keys).to eq(dumped_json)
      end
    end

    context 'when routes are wrapped in an optional scope segment' do
      subject(:schema) { build(:schema, :json_api, rails_routes: [scoped_route]) }

      let(:scoped_route) do
        build(:fake_rails_route, app: 'dummy_app_json_api', path: '(/:tenant_token)/api/v1/users(.:format)')
      end

      it 'still selects the route and keeps the unscoped path key' do
        expect(schema.as_json[:paths].keys).to contain_exactly('/users')
      end
    end
  end
end
