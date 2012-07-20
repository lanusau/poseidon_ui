class SessionsController < ApplicationController

  # GET /session/new
  def new
    # Just display login page
  end

  # POST /session
  def create
    user = User.find_by_login(params[:login])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_url, :notice => "Logged in!"
    else
      flash[:error] = "Invalid login"
      render "new"
    end
  end

  # DELETE /session/1
  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "Logged out!"
  end
end
