# frozen_string_literal: true

RSpec.describe GraphqlToRest::Schema::JsonApi::Components::Schemas::TypeToSchemas do
  describe '.call' do
    subject(:call) do
      described_class.call(
        graphql_type: graphql_type,
        cached_schemas: cached_schemas,
        route: route
      )
    end

    let(:graphql_type) { GraphqlToRest::DummyAppShared::Types::UserType }
    let(:cached_schemas) { {} }
    let(:route) { build(:route_decorator) }

    it 'returns correct schemas for return type and inner enum types' do
      expect(call.keys).to match_array(%w[User GenderEnum Post])
      expect(call['User']).to eq(
        type: 'object',
        properties: {
          'id' => { type: 'string' },
          'email' => { type: 'string' },
          'fullName' => { type: 'string' },
          'gender' => { '$ref' => '#/components/schemas/GenderEnum' },
          'posts' => {
            type: 'array',
            items: { '$ref' => '#/components/schemas/Post' }
          }
        },
        required: %w[email fullName id],
      )
    end
  end
end
