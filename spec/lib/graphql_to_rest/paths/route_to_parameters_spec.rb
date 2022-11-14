# frozen_string_literal: true


RSpec.describe GraphqlToRest::Paths::RouteToParameters do
  describe '.call' do
    subject(:call) { described_class.call(route: route) }

    let(:route) do
      GraphqlToRest::Paths::RouteDecorator.new(
        rails_route: rails_route,
        graphql_schema: graphql_schema
      )
    end

    let(:rails_route) do
      rails_route_double(:post, '/api/v1/:some_param/users(.:format)', "users#create")
    end

    let(:graphql_schema) { GraphqlToRest::DummyApp1::Schema }

    it 'returns correct parameters' do
      expect(call.count).to eq(2)
      expect(call[0]).to include(name: 'fields[User]')
      expect(call[1]).to eq(
        name: 'some_param',
        in: 'path',
        required: true,
        schema: {
          type: 'string'
        }
      )
    end
  end
end
