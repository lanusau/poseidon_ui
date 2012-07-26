# Load top menu (for all modules) 
PoseidonV3::Application.config.main_menu = YAML.load_file("#{Rails.root}/config/main_menu.yml")

# Load and sub-menu (for this module only)
PoseidonV3::Application.config.submenu = YAML.load_file("#{Rails.root}/config/submenu.yml")