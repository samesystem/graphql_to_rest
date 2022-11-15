# frozen_string_literal: true

RSpec.describe GraphqlToRest::Paths::RouteToFieldsetParameter do
  describe '.call' do
    subject(:call) { described_class.call(route: route) }

    let(:route) { route_double_for('users#create') }

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
