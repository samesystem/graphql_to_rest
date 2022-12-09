# frozen_string_literal: true

require 'graphql'

module GraphqlToRest
  module DummyAppShared
    module Types
      class UserType < GraphQL::Schema::Object
        require_relative './post_type'
        require_relative './gender_enum'

        field :id, ID, 'User ID', null: false
        field :email, String, 'User email', null: false
        field :full_name, String, 'User full name', null: false
        field :gender, GenderEnum, 'User gender', null: true
        field :posts, [PostType, {null: false}], 'User posts', null: true
      end
    end
  end
end
