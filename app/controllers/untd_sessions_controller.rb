require 'sso'
#
# This class replaces sessions controller to use
# UNTD SSO authentication instead of password
# authentication against database table
#
class UntdSessionsController < ApplicationController

  skip_before_filter :authorize
  
  # GET /session/new
  def new

    # If sso_token parameter is passed, this means this is callback from SSO
    if params[:sso_token]
      login = SSO.getAuthenticatedUsername(params[:sso_token],"POSEIDON")
      @error = "Invalid authentication from SSO" and return if login.nil?

      user = User.find_by_login(login)

      # User authenticated fine, but there is no record in the table
      if user.nil?
        @error = "Your SSO authentication is succesfull but you are not allowed to use this application"
        return
      end

      # Log user in
      session[:user_id] = user.id
      redirect_to root_url, :notice => "Logged in!" and return

    end

    # If error is passed in flash, then render "new" which
    # will display some information
    # Otherwise, redirect to SSO page
    if flash[:error] 
      @error = flash[:error] 
    else      
      redirect_to SSO.getLoginUrl("Poseidon","POSEIDON",request.url) and return;
    end

  end

  # DELETE /session/1
  def destroy
    session[:user_id] = nil
  end
end
