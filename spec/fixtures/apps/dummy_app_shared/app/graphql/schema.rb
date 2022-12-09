# frozen_string_literal: true

require_relative './types'

module GraphqlToRest
  module DummyAppShared
    class Schema < GraphQL::Schema
      query Types::QueryType
      mutation Types::MutationType
    end
  end
end
