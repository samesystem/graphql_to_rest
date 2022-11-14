# frozen_string_literal: true

RSpec.describe GraphqlToRest::Paths::RouteToFieldsetParameter do
  describe '.call' do
    subject(:call) { described_class.call(route: route) }

    let(:route) do
      GraphqlToRest::Paths::RouteDecorator.new(
        rails_route: rails_route,
        graphql_schema: graphql_schema
      )
    end

    let(:graphql_schema) { GraphqlToRest::DummyApp1::Schema }

    let(:rails_route) do
      rails_route_double(:post, '/api/v1/users(.:format)', "users#create")
    end

    it 'returns correct schema' do
      expect(call).to eq(
        description: 'Comma separated list of #/components/schemas/User fields that must be returned',
        name: 'fields[User]',
        in: 'query',
        required: false,
        style: 'simple',
        explode: false,
        schema: {
          type: 'array',
          default: 'id,email',
          items: {
            type: 'string',
            enum: %w[email fullName id]
          }
        }
      )
    end
  end
end
