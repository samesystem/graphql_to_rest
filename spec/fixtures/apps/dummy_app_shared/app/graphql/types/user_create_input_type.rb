# frozen_string_literal: true

require 'graphql'
require_relative './gender_enum'
require_relative './location_input_type'
require_relative './wish_item_input_type'

module GraphqlToRest
  module DummyAppShared
    module Types
      class UserCreateInputType < GraphQL::Schema::InputObject
        graphql_name 'UserCreateInput'

        argument :email, type: String, required: true
        argument :full_name, type: String, required: true
        argument :location, type: LocationInputType, required: false
        argument :gender, type: GenderEnum, required: false
        argument :wish_items, type: [WishItemInputType], required: false
      end
    end
  end
end
