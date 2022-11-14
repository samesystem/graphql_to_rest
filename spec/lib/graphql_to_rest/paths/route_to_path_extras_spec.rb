# frozen_string_literal: true


RSpec.describe GraphqlToRest::Paths::RouteToPathExtras do
  describe '.call' do
    subject(:call) { described_class.call(route: route) }

    let(:route) do
      GraphqlToRest::Paths::RouteDecorator.new(
        rails_route: rails_route,
        graphql_schema: graphql_schema
      )
    end

    let(:rails_route) do
      rails_route_double('post', '/api/v1/users(.:format)', "users#create")
    end

    let(:graphql_schema) { GraphqlToRest::DummyApp1::Schema }

    let(:path_schemas_dir) { 'spec/fixtures/apps/dummy_app1/app/open_api/paths' }

    let(:open_api_configuration) do
      config = GraphqlToRest::OpenApiConfiguration.new
      config.path_schemas_dir(path_schemas_dir)
      config
    end

    around do |example|
      GraphqlToRest.with_configuration(open_api_configuration, &example)
    end

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
