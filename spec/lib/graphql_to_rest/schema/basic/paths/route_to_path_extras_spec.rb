# frozen_string_literal: true

RSpec.describe GraphqlToRest::Schema::Basic::Paths::RouteToPathExtras do
  describe '.call' do
    subject(:call) do
      described_class.call(
        route: route,
        path_schemas_dir: path_schemas_dir,
      )
    end

    let(:route) { build(:route_decorator, schema_builder: schema_builder) }
    let(:path_schemas_dir) { 'spec/fixtures/apps/dummy_app_json_api/app/open_api/paths' }
    let(:schema_builder) { build(:schema, path_schemas_dir: path_schemas_dir) }

    before do
      allow(File).to receive(:read).and_call_original
    end

    it 'reads schema details from file' do
      call
      expected_path =
        'spec/fixtures/apps/dummy_app_json_api/' \
        'app/open_api/paths/' \
        'graphql_to_rest/dummy_app_json_api/api/v1/users_controller.yml'

      expect(File).to have_received(:read).with(expected_path)
    end

    it 'includes dynamic parameter names' do
      parameters = call.fetch('/users').fetch('post').fetch('parameters')
      expect(parameters.pluck('name')).to include('fields[User]')
    end
  end
end
