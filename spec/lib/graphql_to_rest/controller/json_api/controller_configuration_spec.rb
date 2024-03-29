# frozen_string_literal: true


RSpec.describe GraphqlToRest::Controller::JsonApi::ControllerConfiguration do
  subject(:controller_configuration) { described_class.new }

  describe '#model' do
    subject(:model) { controller_configuration.model(model_name) }

    let(:model_name) { 'User' }

    it 'returns model with given name' do
      expect(model).to be_a(GraphqlToRest::Controller::JsonApi::ModelConfiguration)
      expect(model.name).to eq(model_name)
    end
  end

  describe '#action' do
    subject(:action) { controller_configuration.action(action_name) }

    let(:action_name) { 'index' }

    it 'always returns action configuration' do
      expect(action).to be_a(GraphqlToRest::Controller::JsonApi::ActionConfiguration)
    end
  end
end
