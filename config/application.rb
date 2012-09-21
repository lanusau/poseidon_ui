require File.expand_path('../boot', __FILE__)

require 'rails/all'

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  # Bundler.require(*Rails.groups(:assets => %w(development test)))
  # If you want your assets lazily compiled in production, use this line
  Bundler.require(:default, :assets, Rails.env)
end

module PoseidonV3
  class Application < Rails::Application

    # Key for password encryption. If you change this then every password in
    # table PSD_TARGET  will have to be reset
    config.secret = 'm0nitr$this'
    
    # Location of main menu file
    config.main_menu_config_file = "#{config.root}/config/main_menu.yml"

    # Use AES-128 for encryption.
    Encryptor.default_options.merge!(:algorithm => 'aes-128-cbc')

    # Custom directories with classes and modules you want to be autoloadable.
    config.autoload_paths += %W(#{config.root}/extras)

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    config.time_zone = 'Pacific Time (US & Canada)'

    # Store dates in database in local timezone
    config.active_record.default_timezone = :local

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password,:monitor_password]

    # Enable escaping HTML in JSON.
    config.active_support.escape_html_entities_in_json = true

    # Enforce whitelist mode for mass assignment.
    config.active_record.whitelist_attributes = true
  
    config.active_record.table_name_prefix ="psd_"
    config.active_record.primary_key_prefix_type = :table_name_with_underscore
    config.active_record.pluralize_table_names = false

    # Enable the asset pipeline
    config.assets.enabled = true

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'

  end
end
