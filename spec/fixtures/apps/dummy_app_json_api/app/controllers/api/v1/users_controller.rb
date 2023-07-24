# frozen_string_literal: true

module GraphqlToRest
  module DummyAppJsonApi
    module Api
      module V1
        class UsersController
          include ::GraphqlToRest::Controller::JsonApi

          open_api do |c|
            c.model('User') do |m|
              m.nested_fields(%i[posts.id])
              m.default_fields(%i[id email])
            end

            c.action(:show) do |a|
              a.graphql_action(:user)
            end

            c.action(:index_paginated) do |a|
              a.graphql_action(:usersPaginated)
            end

            c.action(:create) do |a|
              a.graphql_action(:createUser)
              a.graphql_input_type_path(:input)
            end
          end
        end
      end
    end
  end
end
