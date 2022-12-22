# frozen_string_literal: true

require 'graphql_to_rest/controller/json_api/fieldset_to_graphql_output'

RSpec.describe GraphqlToRest::Controller::JsonApi::FieldsetToGraphqlOutput do
  describe '.call' do
    subject(:call) { described_class.call(fieldset: fieldset) }

    context 'without nesting' do
      let(:fieldset) { ['id', 'email'] }

      it { is_expected.to eq([:id, :email]) }
    end

    context 'with symbols' do
      let(:fieldset) { %i[a b c d] }

      it { is_expected.to eq(%i[a b c d]) }
    end

    context 'with nesting level of two' do
      let(:fieldset) { ['a', 'b.c'] }

      it { is_expected.to eq([:a, { b: [:c]}]) }
    end

    context 'with nesting level of three' do
      let(:fieldset) { ['a', 'b.c', 'd.e.f'] }

      it 'returns correct structure' do
        expect(call).to eq(
          [
            :a,
            {
              b: [
                :c
              ],
              d: [
                {
                  e: [
                    :f
                  ]
                }
              ]
            }
          ]
        )
      end
    end

    context 'with same name keys' do
      let(:fieldset) { ['a', 'a.a', 'a.b'] }

      it 'returns correct structure' do
        expect(call).to eq(
          [
            {
              a: [
                :a,
                :b
              ]
            }
          ]
        )
      end
    end

    context 'with duplicated paths' do
      let(:fieldset) { ['a.b.c', 'a.b.c', 'a.d', 'a.d'] }

      it 'returns correct structure' do
        expect(call).to eq(
          [
            {
              a: [
                :d,
                {
                  b: [
                    :c
                  ]
                }
              ]
            }
          ]
        )
      end
    end
  end
end
