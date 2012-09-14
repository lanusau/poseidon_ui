# Load top menu (for all modules) 
PoseidonV3::Application.config.main_menu = YAML.load_file(PoseidonV3::Application.config.main_menu_config_file)

# Load and sub-menu (for this module only)
PoseidonV3::Application.config.submenu = YAML.load_file("#{Rails.root}/config/submenu.yml")