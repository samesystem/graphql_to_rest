# frozen_string_literal: true

module GraphqlToRest
  module DummyAppJsonApi
    module Api
      module V1
        class UsersController
          include ::GraphqlToRest::Controller::JsonApi

          open_api do |c|
            c.model('User')

            c.action(:show) do |a|
              a.graphql_action(:user)
              a.fieldset_parameter
               .nested_fields('posts.id')
               .default_value(%i[id email])
            end

            c.action(:index_paginated) do |a|
              a.graphql_action(:usersPaginated)
              a.fieldset_parameter
               .nested_fields('posts.id')
               .default_value(%i[id email])
            end

            c.action(:create) do |a|
              a.graphql_action(:createUser)
              a.fieldset_parameter
               .nested_fields('posts.id')
               .default_value(%i[id email])
              a.graphql_input_type_path(:input)
            end
          end
        end
      end
    end
  end
end
