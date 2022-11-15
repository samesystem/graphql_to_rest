# frozen_string_literal: true

require 'graphql_to_rest/paths'
require 'graphql_to_rest/components'

module GraphqlToRest
  # openapi.json file generator
  class Schema
    OPENAPI_VERSION = '3.0.2'

    attr_reader :tags, :servers, :info, :security_schemes, :graphql_schema, :path_schemas_dir

    def initialize(tags: [], servers: [], info: {}, security_schemes: [], graphql_schema:, path_schemas_dir:)
      @tags = tags
      @servers = servers
      @info = info
      @security_schemes = security_schemes
      @graphql_schema = graphql_schema
      @path_schemas_dir = path_schemas_dir
    end

    def as_json
      {
        **general_info,
        paths: paths,
        components: {
          schemas: components_schemas,
          securitySchemes: security_schemes,
          requestBodies: components_request_bodies
        }
      }
    end

    def paths
      routes
        .map { route_to_path_schema(_1) }
        .reduce(:deep_merge)
    end

    def general_info
      {
        openapi: OPENAPI_VERSION,
        info: info,
        servers: servers,
        tags: tags,
        security: security
      }
    end

    def security
      security_schemes.keys.map { |key| { key => [] } }
    end

    def components_schemas
      Components::RoutesToComponentsSchemas.call(routes: routes)
    end

    def components_request_bodies
      {}
    end

    def routes
      @routes ||= rails_api_routes.map do |route|
        Paths::RouteDecorator.new(
          rails_route: route,
          graphql_schema: graphql_schema
        )
      end
    end

    private

    def route_to_path_schema(decorated_route)
      Paths::RouteToPathSchema.call(
        route: decorated_route,
        path_schemas_dir: path_schemas_dir
      )
    end

    def server_urls
      @server_urls ||= servers.map { _1[:url] }
    end

    def rails_api_routes
      all_rails_routes.select do |route|
        route_url = route.path.spec.to_s
        server_urls.any? { |prefix| route_url.start_with?(prefix) }
      end
    end

    def all_rails_routes
      Rails.application.routes.routes
    end

    def components_schema_for(type)
      GraphqlToComponentsSchema.call(type: type)
    end

    def components_request_body_for(graphql_input_class, subtype: nil)
      GraphqlToComponentsRequestBody.call(type: graphql_input_class, subtype: subtype)
    end
  end
end
