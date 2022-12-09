# frozen_string_literal: true

RSpec.describe GraphqlToRest::Schema::JsonApi::Paths::RouteToParameters do
  describe '.call' do
    subject(:call) do
      described_class.call(route: route)
    end

    let(:route) { build(:route_decorator, :json_api, path: '/api/v1/:some_param/users(.:format)') }

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
