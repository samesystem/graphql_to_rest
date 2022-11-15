# frozen_string_literal: true

RSpec.describe GraphqlToRest::Components::RoutesToComponentsSchemas do
  describe '.call' do
    subject(:call) { described_class.call(routes: routes) }

    let(:routes) { [route] }
    let(:route) { route_double_for('users#create') }

    it 'returns correct schemas for return type and inner enum types' do
      expect(call.keys).to match_array(%w[User GenderEnum])
    end
  end
end
