# frozen_string_literal: true

RSpec.describe GraphqlToRest::Paths::GraphqlToPathRequestBody do
  describe '.call' do
    subject(:call) { described_class.call(graphql_input: graphql_input, extra_specs: {}) }

    let(:graphql_input) { GraphqlToRest::DummyApp1::Types::UserCreateInputType }
    let(:extra_specs) { {} }

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
