# frozen_string_literal: true

RSpec.describe GraphqlToRest::Paths::RouteToParameters do
  describe '.call' do
    subject(:call) do
      described_class.call(
        route: route,
        schema_builder: schema_builder
      )
    end

    let(:schema_builder) { build(:schema) }

    let(:route) do
      route_double(:post, '/api/v1/:some_param/users(.:format)', "users#create")
    end

    it 'returns correct parameters' do
      expect(call.count).to eq(2)
      expect(call[0]).to include(name: 'fields[User]')
      expect(call[1]).to eq(
        name: 'some_param',
        in: 'path',
        required: true,
        schema: {
          type: 'string'
        }
      )
    end
  end
end
