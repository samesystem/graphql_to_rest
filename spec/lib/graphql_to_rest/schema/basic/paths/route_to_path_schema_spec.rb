# frozen_string_literal: true

RSpec.describe GraphqlToRest::Schema::Basic::Paths::RouteToPathSchema do
  describe '.call' do
    subject(:call) do
      described_class.call(route: route)
    end

    let(:route) { build(:route_decorator, schema_builder: schema_builder) }
    let(:path_schemas_dir) { 'spec/fixtures/apps/dummy_app_json_api/app/open_api/paths' }
    let(:schema_builder) { build(:schema, path_schemas_dir: path_schemas_dir) }

    before do
      allow(GraphqlToRest::Schema::Basic::Paths::RouteToPathExtras)
        .to receive(:call).and_call_original

      allow(GraphqlToRest::Schema::Basic::Paths::RouteToParameters)
        .to receive(:call).and_call_original
    end

    it 'calculates path extras from route' do
      call

      expect(GraphqlToRest::Schema::Basic::Paths::RouteToPathExtras)
        .to have_received(:call).with(hash_including(route: route))
    end

    it 'extracts parameters from route' do
      call

      expect(GraphqlToRest::Schema::Basic::Paths::RouteToParameters)
        .to have_received(:call).with(route: route)
    end

    it 'has correct structure' do
      path_spec = call.fetch('/users').fetch('post')
      expect(path_spec.keys).to match_array(%w[parameters requestBody responses])
    end

    context 'with route without input' do
      let(:route) { build(:route_decorator, to: 'users#show') }

      it 'does not generate requestBody' do
        path_spec = call.fetch('/users/{id}').fetch('get')
        expect(path_spec.keys).not_to include('requestBody')
      end
    end
  end
end
