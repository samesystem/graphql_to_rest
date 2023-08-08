# Controller configuration

In oder to make controller configurable, you need to include `GraphqlToRest::Controller:JsonApi` or `GraphqlToRest::Controller:Basic` module:

```ruby
class UsersController < ApiController
  include GraphqlToRest::Controller::JsonApi
end
```

`GraphqlToRest::Controller:JsonApi` includes additional methods which makes your API compatible with JSON:API standard.

Both modules adds method `open_api` which allows configuring your controller.

## `open_api`

`open_api` is a method which accepts block and allows setting all the OpenAPI specific configurations:

```ruby
class UsersController < ApiController
  include GraphqlToRest::Controller::JsonApi

  open_api do |c|
    c.model('User')
    c.action(:index).graphql_action(:users)
  end
end
```

## `open_api.model`

`model` method accepts model name and allows setting common configuration for all controller actions:

```ruby
class UsersController < ApiController
  include GraphqlToRest::Controller::JsonApi

  open_api do |c|
    c.model('User') do |m|
      # Allows fetching user posts:
      m.nested_fields(%[posts.title posts.id posts.createdAt])

      # Returns these fields of `fields[User]` param is not given
      m.default_fields(%w[id email fullName])
    end
  end
end
```

