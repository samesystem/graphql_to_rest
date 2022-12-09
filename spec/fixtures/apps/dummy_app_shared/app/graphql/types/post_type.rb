# frozen_string_literal: true

require 'graphql'

module GraphqlToRest
  module DummyAppShared
    module Types
      class PostType < GraphQL::Schema::Object
        require_relative './user_type'

        field :id, ID, 'Post ID', null: false
        field :content, String, 'Post content', null: false
        field :author, Types::UserType, 'Post author', null: false
      end
    end
  end
end
