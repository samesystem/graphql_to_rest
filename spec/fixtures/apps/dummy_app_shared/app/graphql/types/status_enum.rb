# frozen_string_literal: true

module GraphqlToRest
  module DummyAppShared
    module Types
      class StatusEnum < GraphQL::Schema::Enum
        graphql_name 'StatusEnum'

        value 'Active'
        value 'Inactive'
      end
    end
  end
end
