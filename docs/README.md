# GraphqlToRest

Tool for serving GraphQL schema as fully functional and documented REST + swagger + JSON:API API.

## Installation

Install the gem and add to the application's Gemfile by executing:

```bash
    $ bundle add graphql_to_rest
```

If bundler is not being used to manage dependencies, install the gem by executing:

```bash
    $ gem install graphql_to_rest
```

## Quick start

### Include GraphqlToRest controller module in your OpenAPI controllers

```ruby
module Api
  # Base controller for all API controllers
  class OpenApiController < ApplicationController
    include GraphqlToRest::Controller::JsonApi
  end
end
```

### Add configuration for each controller action

```ruby
module Api
  # Base controller for all API controllers
  class UsersController < OpenApiController
    open_api do |c|
      c.model('User').default_fields(%i[id email fullName])

      c.action(:index) do |a|
        a.graphql_action(:getUsers)
      end
    end

    def index
      # MakeGraphqlQuery - imaginary class that makes actual GQL requests
      # `graphql_action_name` and `action_output_fields` - methods provided by GraphqlToRest
      MakeGraphqlQuery.call(
        action_name: graphql_action_name,
        output_fields: action_output_fields
      )
    end
  end
end
```

### Add rake task for generating openapi.json file

Put this somewhere in the rake task

```ruby
    # lib/tasks/openapi.rake
    desc 'Updates openapi.json file'
    task update_openapi: :environment do
      open_api = GraphqlToRest::Schema.new(
        graphql_schema: Schema,
        path_schemas_dir: Rails.root.join('lib/open_api/path_schemas')
      )

      File.write('public/openapi.json', JSON.pretty_generate(open_api.as_json))
    end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/graphql_to_rest. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/graphql_to_rest/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the GraphqlToRest project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/graphql_to_rest/blob/master/CODE_OF_CONDUCT.md).
