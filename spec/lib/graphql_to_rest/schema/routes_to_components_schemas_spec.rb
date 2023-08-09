# frozen_string_literal: true

RSpec.describe GraphqlToRest::Schema::RoutesToComponentsSchemas do
  describe '.call' do
    subject(:call) do
      described_class.call(routes: routes)
    end

    let(:routes) { [route] }
    let(:route) { build(:route_decorator) }

    it 'returns correct schemas for return type and inner enum types' do
      expect(call.keys).to match_array(%w[User GenderEnum Post])
    end

    context 'when route has query parameters' do
      let(:route) { build(:route_decorator, :users_paginated) }

      it 'generates schemas for query parameters too' do
        expect(call.keys).to match_array(%w[User UserConnection GenderEnum Post UsersFilter StatusEnum])
      end
    end
  end
end
