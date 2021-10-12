require_relative "boot"

# Pick the frameworks you want:
require "active_record/railtie"
require "action_controller/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RailsMiniApp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Don't generate system test files.
    config.generators.system_tests = nil

    log_formatter    = ::Logger::Formatter.new
    logger           = ActiveSupport::Logger.new(config.paths["log"].first, shift_age = "daily")
    logger.formatter = log_formatter
    config.logger    = ActiveSupport::TaggedLogging.new(logger)

    def load_console(app = self)
      super
      irbrc = Rails.root.join(".irbrc")
      load(irbrc) if irbrc.file?
    end
  end
end
