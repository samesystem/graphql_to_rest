# frozen_string_literal: true

RSpec.describe GraphqlToRest::Paths::GraphqlToSuccessResponse do
  describe '.call' do
    subject(:call) do
      described_class.call(
        type: type,
        schema_builder: schema_builder
      )
    end

    let(:type) { GraphqlToRest::DummyApp1::Types::UserType }
    let(:schema_builder) { build(:schema) }

    it 'returns correct schema' do
      actual_schema = call[:'200'][:content][:'application/json'][:schema]
      expect(actual_schema[:properties].keys).to match_array(%i[links meta data])

      actual_data = actual_schema[:properties][:data]
      expect(actual_data[:properties]).to eq(
        attributes: { '$ref': '#/components/schemas/User' }
      )
    end
  end
end
