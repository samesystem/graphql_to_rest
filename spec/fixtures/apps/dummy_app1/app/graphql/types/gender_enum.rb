# frozen_string_literal: true

module GraphqlToRest
  module DummyApp1
    module Types
      class GenderEnum < GraphQL::Schema::Enum
        graphql_name 'GenderEnum'

        value 'FEMALE'
        value 'MALE'
      end
    end
  end
end
