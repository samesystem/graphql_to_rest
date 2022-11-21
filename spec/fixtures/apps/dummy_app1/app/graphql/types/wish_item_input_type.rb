# frozen_string_literal: true

require 'graphql'

module GraphqlToRest
  module DummyApp1
    module Types
      class WishItemInputType < GraphQL::Schema::InputObject
        graphql_name 'WishItemInput'

        argument :name, type: String, required: true
      end
    end
  end
end
