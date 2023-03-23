# frozen_string_literal: true

require 'graphql'

module GraphqlToRest
  module DummyAppShared
    module Types
      class UnusedItemType < GraphQL::Schema::Object
        field :id, ID, null: false
      end
    end
  end
end
