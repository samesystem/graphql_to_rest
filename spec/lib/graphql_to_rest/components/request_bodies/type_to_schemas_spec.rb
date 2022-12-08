# frozen_string_literal: true

RSpec.describe GraphqlToRest::Components::RequestBodies::TypeToSchemas do
  describe '.call' do
    subject(:call) do
      described_class.call(
        graphql_type: graphql_type,
        cached_schemas: cached_schemas,
        schema_builder: schema_builder
      )
    end

    let(:schema_builder) { build(:schema) }
    let(:graphql_type) { GraphqlToRest::DummyApp1::Types::UserCreateInputType }
    let(:cached_schemas) { {} }

    it 'returns correct schemas for return type and inner types' do
      expect(call.keys).to match_array(%w[UserCreateInput LocationInput WishItemInput])

      expect(call['UserCreateInput']).to eq(
        type: 'object',
        properties: {
          'email' => { type: 'string' },
          'fullName' => { type: 'string' },
          'gender' => { '$ref' => '#/components/schemas/GenderEnum' },
          'location' => { '$ref' => '#/components/requestBodies/LocationInput' },
          'wishItems' => {
            type: 'array',
            items: {
              '$ref' => '#/components/requestBodies/WishItemInput'
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
  end
end
