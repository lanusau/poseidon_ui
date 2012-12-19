# Load top menu (for all modules) 
PoseidonV3::Application.config.main_menu = Hash.new
Dir["#{Rails.root}/config/menu/*.yml"].sort.each do |menu_file|
  PoseidonV3::Application.config.main_menu.merge! YAML.load_file(menu_file)
end

# Load and sub-menu (for this module only)
PoseidonV3::Application.config.submenu = YAML.load_file("#{Rails.root}/config/submenu.yml")