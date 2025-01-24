# frozen_string_literal: true

RSpec.describe GraphqlToRest::Controller::JsonApi::ActionConfiguration do
  subject(:action_configuration) { described_class.new(controller_config: controller_config) }

  let(:controller_config) { GraphqlToRest::Controller::JsonApi::ControllerConfiguration.new }

  describe '#query_parameter' do
    subject(:query_parameter) { action_configuration.query_parameter(name) }

    let(:name) { 'name' }

    it 'always returns query parameter configuration' do
      expect(query_parameter)
        .to be_a(GraphqlToRest::Controller::Basic::ParameterConfiguration)
    end
  end

  describe '#path_parameter' do
    subject(:path_parameter) { action_configuration.path_parameter(name) }

    let(:name) { 'name' }

    it 'always returns path parameter configuration' do
      expect(path_parameter)
        .to be_a(GraphqlToRest::Controller::Basic::ParameterConfiguration)
    end
  end

  describe '#fieldset_parameter' do
    subject(:fieldset_parameter) { action_configuration.fieldset_parameter }

    it 'returns parameter configuration' do
      expect(fieldset_parameter)
        .to be_a(GraphqlToRest::Controller::Basic::ParameterConfiguration)
    end
  end

  describe '#graphql_action' do
    subject(:graphql_action) { action_configuration.graphql_action }

    let(:action_name) { :createUser }

    context 'when action is not set' do
      it { is_expected.to be_nil }
    end

    context 'when action is set' do
      before { action_configuration.graphql_action(action_name) }

      it 'returns action name' do
        expect(graphql_action).to eq(action_name)
      end
    end
  end

  describe '#graphql_output_type_path' do
    subject(:graphql_output_type_path) { action_configuration.graphql_output_type_path }

    context 'when path is not set' do
      it { is_expected.to be_empty }
    end

    context 'when path is set' do
      let(:path) { %i[path to nested field] }

      before do
        action_configuration.graphql_output_type_path(path)
      end

      it 'returns set path' do
        expect(graphql_output_type_path).to eq(path)
      end
    end
  end

  describe '#model' do
    subject(:model) { action_configuration.model }

    before { controller_config.model('User') }

    it 'returns the model configuration' do
      expect(model).to be_a(GraphqlToRest::Controller::JsonApi::ModelConfiguration)
    end

    it 'inherits the model name from a controller configuration' do
      expect(model.name).to eq('User')
    end

    context 'when the model name is provided' do
      subject(:model) { action_configuration.model('AnotherResponse') }

      it 'overrides the model name' do
        expect(model.name).to eq('AnotherResponse')
      end
    end
  end
end
