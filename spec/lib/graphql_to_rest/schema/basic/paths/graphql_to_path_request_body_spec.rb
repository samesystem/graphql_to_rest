# frozen_string_literal: true

RSpec.describe GraphqlToRest::Schema::Basic::Paths::GraphqlToPathRequestBody do
  describe '.call' do
    subject(:call) do
      described_class.call(
        graphql_input: graphql_input,
        extra_specs: {},
        route: route
      )
      end

    let(:graphql_input) { GraphqlToRest::DummyAppShared::Types::UserCreateInputType }
    let(:extra_specs) { {} }
    let(:route) { build(:route_decorator) }

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
                    attributes: { '$ref' => '#/components/schemas/UserCreateInput' }
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

    context 'when input is a list' do
      let(:graphql_input) { GraphqlToRest::DummyAppShared::Types::UserCreateInputType.to_non_null_type.to_list_type }

      it 'returns attributes as an array' do
        attributes = call.dig('content', 'application/json', 'schema', :properties, :data, :properties, :attributes)

        expect(attributes).to eq(type: 'array', items: { '$ref' => '#/components/schemas/UserCreateInput' })
      end
    end
  end
end
