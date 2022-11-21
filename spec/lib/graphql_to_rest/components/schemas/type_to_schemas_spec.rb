# frozen_string_literal: true

RSpec.describe GraphqlToRest::Components::Schemas::TypeToSchemas do
  describe '.call' do
    subject(:call) do
      described_class.call(graphql_type: graphql_type, cached_schemas: cached_schemas)
    end

    let(:graphql_type) { GraphqlToRest::DummyApp1::Types::UserType }
    let(:cached_schemas) { {} }

    it 'returns correct schemas for return type and inner enum types' do
      expect(call.keys).to match_array(%w[User GenderEnum])
      expect(call).to eq(
        'User' => {
          type: 'object',
          properties: {
            'id' => { type: 'string' },
            'email' => { type: 'string' },
            'fullName' => { type: 'string' },
            'gender' => { '$ref' => '#/components/schemas/GenderEnum' },
          },
          required: %w[email fullName id],
        },
        'GenderEnum' => {
          type: 'string',
          enum: %w[FEMALE MALE]
        }
      )
    end
  end
end
