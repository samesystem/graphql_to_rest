# frozen_string_literal: true

RSpec.describe GraphqlToRest::Schema::Basic::Paths::RouteToParameters do
  describe '.call' do
    subject(:call) do
      described_class.call(route: route)
    end

    let(:route) { build(:route_decorator, path: '/api/v1/:some_param/users(.:format)') }

    it 'returns correct parameters' do
      expect(call.count).to eq(1)
      expect(call).to eq(
        [
          {
            name: 'some_param',
            in: 'path',
            required: true,
            schema: { type: 'string' }
          }
        ]
      )
    end
  end
end
