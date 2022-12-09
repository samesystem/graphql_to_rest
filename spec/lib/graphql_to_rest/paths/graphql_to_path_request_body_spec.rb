# frozen_string_literal: true

RSpec.describe GraphqlToRest::Paths::GraphqlToPathRequestBody do
  describe '.call' do
    subject(:call) do
      described_class.call(
        graphql_input: graphql_input,
        extra_specs: {},
        schema_builder: schema_builder
      )
      end

    let(:graphql_input) { GraphqlToRest::DummyAppShared::Types::UserCreateInputType }
    let(:extra_specs) { {} }
    let(:schema_builder) { build(:schema) }

    it 'returns correct schema' do
      expect(call).to eq(
        'content' => {
          'application/json' => {
            'schema' => {
              type: 'object',
              properties: {
                data: {
                  type: 'object',
                  properties: {
                    attributes: { '$ref': '#/components/requestBodies/UserCreateInput' }
                  },
                  required: %w[attributes]
                }
              },
              required: %w[data]
            }
          }
        }
      )
    end
  end
end
