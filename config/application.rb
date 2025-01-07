require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module CityzonesApplicationServerRails
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Remove a div field_with_errors em campos com erro de validação (causa problemas com o Bootstrap)
    config.action_view.field_error_proc = Proc.new { |html_tag, instance| 
      html_tag.html_safe
    }

    # Não desativa os botões de submit
    config.action_view.automatically_disable_submit_tag = false

    RGeo::ActiveRecord::SpatialFactoryStore.instance.tap do |config|
      # By default, use the GEOS implementation for spatial columns.
      config.default = RGeo::Geos.factory
    
      # But use a geographic implementation for point columns.
      config.register(RGeo::Geographic.spherical_factory(srid: 4326), geo_type: "point")
    end
  end
end
