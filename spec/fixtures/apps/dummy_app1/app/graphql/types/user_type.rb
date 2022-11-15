# frozen_string_literal: true

require 'graphql'
require_relative './gender_enum'

module GraphqlToRest
  module DummyApp1
    module Types
      class UserType < GraphQL::Schema::Object
        field :id, ID, 'User ID', null: false
        field :email, String, 'User email', null: false
        field :full_name, String, 'User full name', null: false
        field :gender, GenderEnum, 'User gender', null: true
      end
    end
  end
end
