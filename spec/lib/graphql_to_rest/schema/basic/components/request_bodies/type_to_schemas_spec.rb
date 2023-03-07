# frozen_string_literal: true

RSpec.describe GraphqlToRest::Schema::Basic::Components::RequestBodies::TypeToSchemas do
  describe '.call' do
    subject(:call) do
      described_class.call(
        graphql_type: graphql_type,
        cached_schemas: cached_schemas,
        route: route
      )
    end

    let(:route) { build(:route_decorator) }
    let(:graphql_type) { GraphqlToRest::DummyAppShared::Types::UserCreateInputType }
    let(:cached_schemas) { {} }

    it 'returns correct schemas for return type and inner types' do
      expect(call.keys).to match_array(%w[UserCreateInput LocationInput WishItemInput])

      expect(call['UserCreateInput']).to eq(
        type: 'object',
        properties: {
          'email' => { type: 'string' },
          'fullName' => { type: 'string' },
          'gender' => { '$ref' => '#/components/schemas/GenderEnum' },
          'location' => { '$ref' => '#/components/schemas/LocationInput' },
          'wishItems' => {
            type: 'array',
            items: {
              '$ref' => '#/components/schemas/WishItemInput'
            }
          }
        },
        required: %w[email fullName]
      )

      expect(call['LocationInput']).to eq(
        type: 'object',
        properties: {
          'country' => { type: 'string' },
          'city' => { type: 'string' }
        },
        required: %w[city country]
      )

      expect(call['WishItemInput']).to eq(
        type: 'object',
        properties: {
          'name' => { type: 'string' }
        },
        required: %w[name]
      )
    end

    context 'when graphql_type is nil' do
      let(:graphql_type) { nil }

      it { is_expected.to eq({}) }
    end
  end
end
