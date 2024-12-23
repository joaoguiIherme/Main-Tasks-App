require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module MainApp
  class Application < Rails::Application
    # Configuração padrão do Rails
    config.load_defaults 7.0

    # Configuração dos hosts permitidos
    config.hosts << "auth_service"
    config.hosts << "main_app"
    config.hosts << "scraping_service"
    config.hosts << "notifications_service"
  end
end
