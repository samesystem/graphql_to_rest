# frozen_string_literal: true

require "active_support/core_ext/hash/indifferent_access"

RSpec.describe GraphqlToRest::Controller do
  subject(:controller_instance) { controller_class.new(params: params) }

  let(:controller_class) do
    Class.new do
      include GraphqlToRest::Controller

      open_api do |c|
        c.model('User')
        c.action(:create) do |a|
          a.fieldset_parameter.default_value(%w[id email])
          a.graphql_action('createUser')
        end
      end

      def initialize(params: {}, action_name: :create)
        @params = HashWithIndifferentAccess.new(params)
        @action_name = action_name
      end

      private

      attr_reader :params, :action_name
    end
  end

  let(:params) { {} }

  describe '.open_api' do
    subject(:open_api) { controller_class.open_api }

    it 'returns configuration' do
      expect(open_api).to be_a(GraphqlToRest::Controller::ControllerConfiguration)
    end
  end

  describe '#fieldset' do
    subject(:fieldset) { controller_instance.send(:fieldset) }

    context 'when params does not have fieldset list' do
      it 'returns default value' do
        expect(fieldset).to eq(%w[id email])
      end
    end

    context 'when params has fieldset list' do
      let(:params) do
        {
          fields: { User: 'id,name' }
        }
      end

      it 'returns fieldset list from params' do
        expect(fieldset).to eq(%w[id name])
      end
    end
  end
end
