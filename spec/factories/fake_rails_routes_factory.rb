# This will guess the User class
FactoryBot.define do
  factory :fake_rails_route, class: 'GraphqlToRest::Test::RailsRoutesHelper::FakeRailsRoute' do
    transient do
      to { 'users#create' }
      path_suffix { %[update show destroy].include?(action) ? '/:id' : '' }
    end
    path { "/api/v1/#{controller}#{path_suffix}(.:format)"  }
    controller { to.split('#').first }
    action { to.split('#').last }
    http_method do
      mapping = { 'create' => 'post', 'update' => 'put', 'destroy' => 'delete' }
      mapping.fetch(action, 'get')
    end
    app { 'dummy_app_json_api' }

    trait :basic do
      app { 'dummy_app_basic' }
    end

    trait :json_api do
      app { 'dummy_app_json_api' }
    end

    initialize_with do
      full_controller = "graphql_to_rest/#{app}/api/v1/#{controller}"
      path_object = GraphqlToRest::Test::RailsRoutesHelper::FakeRailsRoutePath.new(spec: path)

      new(
        path: path_object,
        verb: http_method,
        defaults: { controller: full_controller, action: action }
      )
    end
  end
end
