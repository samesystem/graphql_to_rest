# This will guess the User class
FactoryBot.define do
  factory :route_decorator, class: 'GraphqlToRest::Schema::RouteDecorator' do
    transient do
      to { 'users#create' }
      app { 'dummy_app_json_api' }
      controller { nil }
      path { nil }
      action { nil }

      rails_route_params do
        { to: to, app: app, controller: controller, path: path, action: action }.compact
      end
    end
    rails_route { build(:fake_rails_route, rails_route_params) }
    schema_builder { build(:schema, rails_routes: [rails_route]) }

    trait :json_api do
      schema_builder { build(:schema, :json_api) }
    end

    trait :show_user do
      to { 'users#show' }
    end

    trait :users_paginated do
      to { 'users#index_paginated' }
    end

    initialize_with do
      new(
        rails_route: rails_route,
        schema_builder: schema_builder
      )
    end
  end
end
