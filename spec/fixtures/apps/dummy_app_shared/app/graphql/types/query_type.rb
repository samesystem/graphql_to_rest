# frozen_string_literal: true

require_relative './user_type'
require_relative './users_filter_input_type'

module GraphqlToRest
  module DummyAppShared
    module Types
      class QueryType < GraphQL::Schema::Object
        description 'The query root of this schema'

        field :user, Types::UserType, 'Find a User by ID' do
          argument :id, ID
        end

        field :usersPaginated, Types::UserType.connection_type, 'Paginated users list' do
          argument :filter, Types::UsersFilterInputTYpe
        end

        def user(id:)
          OpenStruct.new(id: id, email: 'john.doe@example.com', full_name: 'John Doe')
        end

        def users_paginated(filter:)
          [user(id: 1)]
        end
      end
    end
  end
end
