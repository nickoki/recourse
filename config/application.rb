require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Recourse
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Do not precompile assets on delpoy (to Heroku, for exmaple)
    config.assets.initialize_on_precompile = false

    # Config Rails to autoload lib/auth.rb
    config.autoload_paths << Rails.root.join('lib')
  end
end
