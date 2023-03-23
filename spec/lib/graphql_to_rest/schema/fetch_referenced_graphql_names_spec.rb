# frozen_string_literal: true

require 'graphql_to_rest/schema/fetch_referenced_graphql_names'

RSpec.describe GraphqlToRest::Schema::FetchReferencedGraphqlNames do
  describe '.call' do
    subject(:call) { described_class.call(route: route) }

    let(:route) { build(:route_decorator) }

    it 'returns graphql names used in given routes' do
      expect(call).to match_array(%w[User Post])
    end
  end
end
