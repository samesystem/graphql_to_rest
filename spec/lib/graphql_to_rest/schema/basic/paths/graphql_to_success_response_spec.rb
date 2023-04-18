# frozen_string_literal: true

RSpec.describe GraphqlToRest::Schema::Basic::Paths::GraphqlToSuccessResponse do
  describe '.call' do
    subject(:call) do
      described_class.call(
        type: type,
        route: route
      )
    end

    let(:type) { GraphqlToRest::DummyAppShared::Types::UserType }
    let(:route) { build(:route_decorator) }

    it 'returns correct schema' do # rubocop:disable RSpec/ExampleLength
      actual_schema = call[:'200'][:content][:'application/json'][:schema]
      expect(actual_schema[:properties].keys).to match_array(%i[links meta data])

      actual_data = actual_schema[:properties][:data]
      expect(actual_data[:properties]).to eq(
        attributes: { '$ref': '#/components/schemas/User' }
      )
    end

    context 'when graphql type is a connection' do
      let(:type) { GraphqlToRest::DummyAppShared::Types::UserType.connection_type }

      it 'returns correct schema' do # rubocop:disable RSpec/ExampleLength
        actual_schema = call[:'200'][:content][:'application/json'][:schema]
        expect(actual_schema[:properties].keys).to match_array(%i[links meta data])

        actual_data = actual_schema[:properties][:data]
        expect(actual_data[:properties]).to eq(
          attributes: { '$ref': '#/components/schemas/UserConnection' }
        )
      end
    end

    context 'when graphql action has description' do
      it 'returns graphql action description with "success response" suffix' do
        expect(call[:'200'][:description]).to eq('Create a user (success response)')
      end
    end

    context 'when graphql action does not have description' do
      before do
        allow(route).to receive(:description).and_return(nil)
      end

      it 'returns default description' do
        expect(call[:'200'][:description]).to eq('Success response')
      end
    end
  end
end
