# frozen_string_literal: true

RSpec.describe GraphqlToRest::Controller::JsonApi::FieldsetParameterConfiguration do
  subject(:fieldset_parameter_configuration) { described_class.new(name: 'fields[User]') }

  let(:controller_config) { GraphqlToRest::Controller::JsonApi::ControllerConfiguration.new }

  describe '#nested_fields' do
    subject(:nested_fields) { fieldset_parameter_configuration.nested_fields(*fields) }

    let(:fields) { [] }

    context 'when no fields are set' do
      context 'when nested fields where not set before' do
        it { is_expected.to be_empty }
      end

      context 'when nested fields where set before' do
        before { fieldset_parameter_configuration.nested_fields('previously.nested.field') }

        it 'returns already set nested fields' do
          expect(nested_fields).to eq(%w[previously.nested.field])
        end
      end
    end

    context 'when fields are set' do
      let(:fields) { 'nested.field' }

      it 'returns fieldset parameter configuration' do
        expect(nested_fields).to be_a(described_class)
      end

      it 'updates nested fields' do
        expect { nested_fields }
          .to change { fieldset_parameter_configuration.nested_fields }
          .from([])
          .to(%w[nested.field])
      end
    end
  end
end
