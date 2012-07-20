class ApplicationController < ActionController::Base
  protect_from_forgery


  # Check if currently logged in user is authorized to execute
  # this particular controller
  def authorize(level=1)
    user = current_user

    # Redirect to login page if not logged in
    redirect_to login_path and return false if user.nil?

    # Check if user's access level is above requested
    if user.access_level > level
      flash[:error] = "You are not authorized to view this page"
      redirect_to login_path and return false
    end

    return true

  end

  private

  # Return information about currently logged in user
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  helper_method :current_user
end
