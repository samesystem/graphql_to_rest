# frozen_string_literal: true

require 'graphql'

module GraphqlToRest
  module DummyAppShared
    module Types
      class UserType < GraphQL::Schema::Object
        require_relative './post_type'
        require_relative './gender_enum'
        require_relative './unused_item_type'

        field :id, ID, 'User ID', null: false
        field :email, String, 'User email', null: false
        field :full_name, String, 'User full name', null: false
        field :gender, GenderEnum, 'User gender', null: true
        field :posts, [PostType, {null: false}], 'User posts', null: true
        field :unusedItems, [UnusedItemType, {null: false}], 'This should not go to OpenAPI json', null: true
      end
    end
  end
end
