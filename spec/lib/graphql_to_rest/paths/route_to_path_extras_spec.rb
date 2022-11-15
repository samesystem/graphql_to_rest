# frozen_string_literal: true


RSpec.describe GraphqlToRest::Paths::RouteToPathExtras do
  describe '.call' do
    subject(:call) do
      described_class.call(
        route: route,
        path_schemas_dir: path_schemas_dir
      )
    end

    let(:route) { route_double_for('users#create') }

    let(:path_schemas_dir) { 'spec/fixtures/apps/dummy_app1/app/open_api/paths' }

    before do
      allow(File).to receive(:read).and_call_original
    end

    it 'reads schema details from file' do
      call

      expected_path = 'spec/fixtures/apps/dummy_app1/app/open_api/paths/graphql_to_rest/dummy_app1/api/v1/users_controller.yml'
      expect(File).to have_received(:read).with(expected_path)
    end

    it 'includes dynamic parameter names' do
      parameters = call.fetch('/users').fetch('post').fetch('parameters')
      expect(parameters.pluck('name')).to include('fields[User]')
    end
  end
end
