# frozen_string_literal: true

RSpec.describe GraphqlToRest::Controller::Basic::ParameterConfiguration do
  subject(:config) { described_class.new(name: name) }

  let(:name) { 'some_param' }

  describe '#default_value' do
    subject(:default_value) { config.default_value }

    context 'when no value is set' do
      it 'returns nil' do
        expect(default_value).to be_nil
      end
    end

    context 'when value is set' do
      let(:value) { 'some_value' }

      before do
        config.default_value(value)
      end

      it 'returns value' do
        expect(default_value).to eq(value)
      end
    end
  end

  describe '#graphql_input_type_path' do
    subject(:graphql_input_type_path) { config.graphql_input_type_path }

    context 'when no value is set' do
      it 'returns empty array' do
        expect(graphql_input_type_path).to eq([])
      end
    end

    context 'when value is set' do
      let(:value) { 'some_path' }

      before do
        config.graphql_input_type_path(value)
      end

      it 'returns value wrapped in array' do
        expect(graphql_input_type_path).to eq([value])
      end
    end
  end

  describe '#required' do
    before do
      config.optional
    end

    it 'changes required? to true' do
      expect { config.required }
        .to change(config, :required?).from(false).to(true)
    end
  end

  describe '#optional' do
    before do
      config.required
    end

    it 'changes required? to false' do
      expect { config.optional }
        .to change(config, :required?).from(true).to(false)
    end
  end
end
