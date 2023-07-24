# frozen_string_literal: true

# frozen_string_literal: true

RSpec.describe GraphqlToRest::Controller::JsonApi::ModelConfiguration do
  subject(:config) { described_class.new }

  describe '#name' do
    subject(:name) { config.name(new_name) }

    let(:new_name) { 'User' }

    context 'when name is not set' do
      subject(:name) { config.name }

      it 'returns nil' do
        expect(name).to be_nil
      end
    end

    context 'when name is set' do
      it 'returns self' do
        expect(name).to eq(config)
      end

      it 'changes name' do
        expect { name }.to change(config, :name).from(nil).to(new_name)
      end
    end
  end

  describe '#nested_fields' do
    subject(:nested_fields) { config.nested_fields(*fields) }

    let(:fields) { %w[id email] }

    context 'when nested_fields is not set' do
      subject(:nested_fields) { config.nested_fields }

      it 'returns empty array' do
        expect(nested_fields).to eq([])
      end
    end

    context 'when nested_fields is set' do
      it 'returns self' do
        expect(nested_fields).to eq(config)
      end

      it 'changes nested_fields' do
        expect { nested_fields }.to change(config, :nested_fields).from([]).to(fields)
      end
    end
  end

  describe '#default_fields' do
    subject(:default_fields) { config.default_fields(*fields) }

    let(:fields) { %w[id email] }

    context 'when default_fields is not set' do
      subject(:default_fields) { config.default_fields }

      it 'returns empty array' do
        expect(default_fields).to eq([])
      end
    end

    context 'when default_fields is set' do
      it 'returns self' do
        expect(default_fields).to eq(config)
      end

      it 'changes default_fields' do
        expect { default_fields }.to change(config, :default_fields).from([]).to(fields)
      end
    end
  end
end
