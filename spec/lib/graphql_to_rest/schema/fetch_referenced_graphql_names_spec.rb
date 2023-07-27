# frozen_string_literal: true

require 'graphql_to_rest/schema/fetch_referenced_graphql_names'

RSpec.describe GraphqlToRest::Schema::FetchReferencedGraphqlNames do
  describe '.call' do
    subject(:call) { described_class.call(route: route) }

    let(:route) { build(:route_decorator) }

    it 'returns graphql names used in given routes' do
      expect(call).to match_array(%w[User Post])
    end

    context 'when route points to paginated type' do
      let(:route) { build(:route_decorator, :users_paginated) }

      it 'returns graphql connection names used in given routes' do
        expect(call).to match_array(%w[User Post])
      end
    end

    context 'when controller has non existing nested fields' do
      let(:route) do
        instance_double(
          GraphqlToRest::Schema::RouteDecorator,
          return_type: GraphqlToRest::DummyAppShared::Types::UserType,
          action_config: action_config
        )
      end

      let(:action_config) do
        GraphqlToRest::Controller::JsonApi::ActionConfiguration.new(controller_config: controller_config)
      end

      let(:controller_config) { GraphqlToRest::Controller::JsonApi::ControllerConfiguration.new }

      before do
        action_config.model.nested_fields(['non_existing_field'])
      end

      it 'raises error' do
        expect { call }
          .to raise_error("Field 'non_existing_field' not found in graphql type 'User'")
      end
    end
  end
end
