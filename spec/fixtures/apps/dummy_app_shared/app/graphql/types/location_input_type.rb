# frozen_string_literal: true

require 'graphql'

module GraphqlToRest
  module DummyAppShared
    module Types
      class LocationInputType < GraphQL::Schema::InputObject
        graphql_name 'LocationInput'

        argument :country, type: String, required: true
        argument :city, type: String, required: true
      end
    end
  end
end
