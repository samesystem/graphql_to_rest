# frozen_string_literal: true

RSpec.describe GraphqlToRest::Schema::RouteDecorator do
  describe '.call' do
    subject(:route_decorator) do
      described_class.new(rails_route: rails_route, schema_builder: schema_builder)
    end

    let(:schema_builder) { build(:schema) }

    let(:rails_route) do
      build(:fake_rails_route, path: '/api/v1/:some_param/users(.:format)')
    end

    describe '#input_type' do
      subject(:input_type) { route_decorator.input_type }

      it 'returns correct input type' do
        expect(input_type.to_type_signature).to eq('UserCreateInput!')
      end

      context 'when route does not have graphql input type' do
        let(:rails_route) do
          build(:fake_rails_route, to: 'users#show', path: '/api/v1/:some_param/users/:id')
        end

        it { is_expected.to be_nil }
      end
    end

    describe '#return_type' do
      subject(:return_type) { route_decorator.return_type.to_type_signature }

      it 'returns correct return type' do
        expect(return_type).to eq('User')
      end
    end

    describe '#action_config' do
      subject(:action_config) { route_decorator.action_config }

      it 'returns correct action config' do
        expect(action_config).to be_a(GraphqlToRest::Controller::JsonApi::ActionConfiguration)
      end
    end

    describe '#controller_config' do
      subject(:controller_config) { route_decorator.controller_config }

      it 'returns correct controller config' do
        expect(controller_config).to be_a(GraphqlToRest::Controller::JsonApi::ControllerConfiguration)
      end
    end

    describe '#http_method' do
      subject(:http_method) { route_decorator.http_method }

      it 'returns correct http method' do
        expect(http_method).to eq('post')
      end
    end

    describe '#open_api_path' do
      subject(:open_api_path) { route_decorator.open_api_path }

      it 'returns correct open api path' do
        expect(open_api_path).to eq('/{some_param}/users')
      end
    end

    describe '#path_parameters' do
      subject(:path_parameters) { route_decorator.path_parameters }

      it 'returns correct path parameters' do
        expect(path_parameters).to eq(%w[some_param])
      end
    end

    describe '#action_name' do
      subject(:action_name) { route_decorator.action_name }

      it 'returns correct action name' do
        expect(action_name).to eq('create')
      end
    end

    describe '#controller_class' do
      subject(:controller_class) { route_decorator.controller_class }

      it 'returns correct controller class' do
        expect(controller_class)
          .to eq(GraphqlToRest::DummyAppJsonApi::Api::V1::UsersController)
      end
    end

    describe '#description' do
      subject(:description) { route_decorator.description }

      it 'returns correct description' do
        expect(description).to eq('Create a user')
      end
    end
  end
end
