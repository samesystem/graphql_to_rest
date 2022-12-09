# frozen_string_literal: true

RSpec.describe GraphqlToRest::Components::Schemas::RoutesToSchemas do
  describe '.call' do
    subject(:call) do
      described_class.call(
        routes: routes,
        schema_builder: schema_builder
      )
    end

    let(:routes) { [route] }
    let(:route) { route_double_for('users#create') }
    let(:schema_builder) { build(:schema, :json_api) }

    it 'returns correct schemas for return type and inner enum types' do
      expect(call.keys).to match_array(%w[User GenderEnum])
    end
  end
end
