class ApplicationController < ActionController::Base

  protect_from_forgery
  before_filter :authorize

  # Main menu for this module
  @@main_menu = "monitoring"
  # Sub menu will be set by each controller
  @@sub_menus = {}

  # Required access levels will be set by each controller
  @@required_access_levels = {}

  # This will be called by controllers to set required access level
  def ApplicationController.set_access_level(level)
    @@required_access_levels[self.name] = level
  end

  # Return required access level
  def required_access_level
    @@required_access_levels[self.class.name]
  end

  # Set/get current sub-menu
  def ApplicationController.set_submenu(submenu)
    @@sub_menus[self.name] = submenu.id2name
  end
  def get_submenu
    @@sub_menus[self.class.name]
  end

  # Check if currently logged in user is authorized to execute
  # this particular controller
  def authorize    
    # Always authorize if access level is guest
    return true if required_access_level == :guest

    user = current_user

    # Redirect to login page if not logged in
    redirect_to login_path and return false if user.nil?

    # Check if user's access level is above requested
    if user.access_level > User.access_level_lookup(required_access_level)
      flash[:error] = "You are not authorized to view this page"
      redirect_to login_path and return false
    end

    return true

  end

  private

  # Return information about currently logged in user
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  rescue
    @current_user = nil
  end

  helper_method :current_user

  # Return processed top menu
  def top_menu
    top_menu_hash = {}
    current_access_level_value = 
      current_user.nil? ? User.access_level_lookup(:guest): current_user.access_level
    # This hash is loaded by menu.rb initializer from YAML file
    PoseidonV3::Application.config.main_menu.each do |key,value|
      # Make a shallow copy of the value hash
      new_value = value.dup
      # Make current main menu item selected
      if key == @@main_menu
        new_value["selected"] = true
      end
      # Add to the top menu hash if access level is right
      top_menu_hash[key] = new_value unless current_access_level_value > value["access_level"]
    end
    return top_menu_hash
  end

  helper_method :top_menu

  # Return processed sub-menu
  def sub_menu
    sub_menu_hash = {}    
    current_access_level_value = 
      current_user.nil? ? User.access_level_lookup(:guest) : current_user.access_level
    # This hash is loaded by menu.rb initializer from YAML file
    PoseidonV3::Application.config.submenu.each do |key,value|
      # Make a shallow copy of the value hash
      new_value = value.dup
      # Make current sub menu item selected
      if key == get_submenu
        new_value["selected"] = true
      end
      # Add to the top menu hash if access level is right
      sub_menu_hash[key] = new_value unless current_access_level_value > value["access_level"]
    end
    return sub_menu_hash
  end

  helper_method :sub_menu
end
