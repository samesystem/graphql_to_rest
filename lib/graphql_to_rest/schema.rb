# frozen_string_literal: true

require 'graphql_to_rest/schema/route_decorator'
require 'graphql_to_rest/schema/routes_to_components_request_bodies'
require 'graphql_to_rest/schema/routes_to_components_schemas'

module GraphqlToRest
  # openapi.json file generator
  class Schema
    OPENAPI_VERSION = '3.0.2'

    attr_reader :tags, :servers, :info, :security_schemes, :graphql_schema, :path_schemas_dir, :graphql_context

    def initialize(
      graphql_schema:,
      path_schemas_dir:,
      tags: [],
      servers: [],
      info: {},
      security_schemes: [],
      rails_routes: nil,
      graphql_context: {}
    )
      @tags = tags
      @servers = servers
      @info = info
      @security_schemes = security_schemes
      @graphql_schema = graphql_schema
      @path_schemas_dir = path_schemas_dir
      @rails_routes = rails_routes || Rails.application.routes.routes
      @graphql_context = graphql_context
    end

    def as_json
      {
        **general_info,
        paths: paths,
        components: {
          schemas: components_schemas.merge(components_request_bodies),
          securitySchemes: security_schemes
        }
      }
    end

    def paths
      routes
        .map { _1.open_api_json_for('paths.{path}.{method}') }
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
      RoutesToComponentsSchemas.call(routes: routes)
    end

    def components_request_bodies
      RoutesToComponentsRequestBodies.call(routes: routes)
    end

    def routes
      @routes ||= rails_api_routes.map do |route|
        RouteDecorator.new(
          rails_route: route,
          schema_builder: self
        )
      end
    end

    def referenced_graphql_names
      @referenced_graphql_names ||= begin
        require 'graphql_to_rest/schema/fetch_referenced_graphql_names'

        routes.flat_map { |route| FetchReferencedGraphqlNames.call(route: route) }.uniq
      end
    end

    def call_service(service, **kwargs)
      service.call(**kwargs, schema_builder: self)
    end

    private

    attr_reader :rails_routes

    def server_urls
      @server_urls ||= servers.map { _1[:url] }
    end

    def rails_api_routes
      rails_routes.select do |route|
        route_url = route.path.spec.to_s
        server_urls.any? { |prefix| route_url.start_with?(prefix) }
      end
    end
  end
end
