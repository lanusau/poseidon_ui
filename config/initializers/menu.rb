# Load top menu (for all modules) 
PoseidonV3::Application.config.main_menu = Hash.new

# In production, directory tree will be similar to below
# railsapps/menu/*.yml
# railsapps/this_application/releases/xxx/
menu_directory =
  FileTest.directory?( "#{Rails.root}/../../../menu" ) ?
    "#{Rails.root}/../../../menu" :
    "#{Rails.root}/config/menu"

Dir["#{menu_directory}/*.yml"].sort.each do |menu_file|
  PoseidonV3::Application.config.main_menu.merge! YAML.load_file(menu_file)
end

# Load and sub-menu (for this module only)
PoseidonV3::Application.config.submenu = YAML.load_file("#{Rails.root}/config/submenu.yml")