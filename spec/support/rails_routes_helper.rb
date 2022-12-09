# frozen_string_literal: true

module GraphqlToRest
  module Test
    module RailsRoutesHelper
      FakeRailsRoute = Struct.new(:path, :verb, :defaults, keyword_init: true)
      FakeRailsRoutePath = Struct.new(:spec, keyword_init: true)
    end
  end
end
