# frozen_string_literal: true


RSpec.describe GraphqlToRest::Paths::RouteToPathSchema do
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
      allow(GraphqlToRest::Paths::RouteToPathExtras)
        .to receive(:call).and_call_original

      allow(GraphqlToRest::Paths::RouteToParameters)
        .to receive(:call).and_call_original
    end

    it 'calculates path extras from route' do
      call

      expect(GraphqlToRest::Paths::RouteToPathExtras)
        .to have_received(:call).with(route: route)
    end

    it 'extracts parameters from route' do
      call

      expect(GraphqlToRest::Paths::RouteToParameters)
        .to have_received(:call).with(route: route)
    end

    it 'has correct structure' do
      path_spec = call.fetch('/users').fetch('post')
      expect(path_spec.keys).to match_array(%w[parameters requestBody responses])
    end
  end
end
