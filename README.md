# APPENV

A simple gem that gives you an application environment configuration object.
Values are loaded from ENV or from an environment file such as `.env`.

Similar to the `.env` feature in Foreman, but these values will be available
to your application no matter how you launch it (script/rails, Passenger,
Unicorn, rake, etc).

For convenience, there is also compatibility with Bash-style environment
declarations in your `.env` file; ie: `export ENV_VAR_NAME="foo"`.

## Example

You'd typically create your configuration object in `config/application.rb`.

```ruby
module ExampleProjectName

  Env = AppEnv::Environment.new { |env, src|
    env.domain = src.my_domain_variable || 'example.com'
    env.set(:access_codes) {
      src.access_codes ? src.access_codes.split : nil
    }
  }

  # class Application < Rails::Application
  # ... etc ...
  #
  # Your config is available globally in ExampleProjectName::Env.
  #

end

```
