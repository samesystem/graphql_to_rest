# frozen_string_literal: true

require 'active_support'
require 'active_support/core_ext/string'
require 'active_support/core_ext/enumerable'
require 'attr_extras'
require "graphql_to_rest/version"

require 'graphql_to_rest/schema'

module GraphqlToRest
  class Error < StandardError; end

  def self.configure
    yield(configuration)
  end

  def self.configuration
    @configuration ||= OpenApiConfiguration.new
  end

  def self.with_configuration(configuration)
    old_configuration = @configuration
    @configuration = configuration
    yield
  ensure
    @configuration = old_configuration
  end
end
