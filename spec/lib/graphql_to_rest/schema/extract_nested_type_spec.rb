# frozen_string_literal: true

RSpec.describe GraphqlToRest::Schema::ExtractNestedType do
  subject(:call) { described_class.call(type: type, nesting_keys: nesting_keys) }

  let(:result_type) { call.to_type_signature }

  describe '.call' do
    context 'with type' do
      let(:type) { GraphqlToRest::DummyAppShared::Types::UserType }

      context 'with level 1 nesting' do
        let(:nesting_keys) { %i[id] }

        it 'returns nested type' do
          expect(result_type).to eq('ID!')
        end
      end

      context 'with level 2 nesting' do
        let(:nesting_keys) { %i[posts id] }

        it 'returns nested type' do
          expect(result_type).to eq('[ID!]')
        end
      end
    end

    context 'with input type' do
      let(:type) { GraphqlToRest::DummyAppShared::Types::UserCreateInputType }

      context 'with level 1 nesting' do
        let(:nesting_keys) { %i[email] }

        it 'returns nested type' do
          expect(result_type).to eq('String!')
        end
      end

      context 'with level 2 nesting' do
        let(:nesting_keys) { %i[location country] }

        it 'returns nested type' do
          expect(result_type).to eq('String!')
        end
      end
    end
  end
end
