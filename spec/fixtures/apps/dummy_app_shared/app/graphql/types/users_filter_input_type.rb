# frozen_string_literal: true

require 'graphql'
require_relative 'status_enum'

module GraphqlToRest
  module DummyAppShared
    module Types
      class UsersFilterInputTYpe < GraphQL::Schema::InputObject
        graphql_name 'UsersFilter'

        argument :id, type: [ID]
        argument :status, type: [StatusEnum]
        argument :name, type: String
      end
    end
  end
end
