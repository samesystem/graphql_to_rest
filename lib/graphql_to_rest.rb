# frozen_string_literal: true

require 'active_support'
require 'active_support/core_ext/string'
require 'active_support/core_ext/enumerable'
require 'attr_extras'

require 'graphql_to_rest/version'
require 'graphql_to_rest/schema'
require 'graphql_to_rest/controller'

module GraphqlToRest
  class Error < StandardError; end

  # Optional leading route scope segment, e.g. "(/:tenant_token)" when the host
  # app wraps its routes in `scope '(:tenant_token)'`.
  OPTIONAL_SCOPE_PREFIX = %r{\A\(/[^)]*\)}.freeze
end
