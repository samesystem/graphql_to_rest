# frozen_string_literal: true

RSpec.describe GraphqlToRest::Schema::JsonApi::Paths::RouteToFieldsetEnumSchema do
  describe '.call' do
    subject(:call) do
      described_class.call(route: route)
    end

    let(:route) { build(:route_decorator) }

    it 'returns correct schema' do
      expect(call).to eq(
        type: 'string',
        enum: %w[email fullName gender id posts.id]
      )
    end
  end
end
