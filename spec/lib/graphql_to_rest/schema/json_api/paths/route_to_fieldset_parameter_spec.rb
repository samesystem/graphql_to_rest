# frozen_string_literal: true

RSpec.describe GraphqlToRest::Schema::JsonApi::Paths::RouteToFieldsetParameter do
  describe '.call' do
    subject(:call) do
      described_class.call(route: route)
    end

    let(:route) { route_double_for('users#create') }
    let(:route) { build(:route_decorator) }

    it 'returns correct schema' do
      expect(call).to eq(
        description: 'Comma separated list of #/components/schemas/User fields that must be returned',
        name: 'fields[User]',
        in: 'query',
        required: false,
        style: 'form',
        explode: false,
        allowReserved: true,
        schema: {
          type: 'array',
          default: 'id,email',
          items: {
            type: 'string',
            enum: %w[email fullName gender id posts.id]
          }
        }
      )
    end
  end
end
