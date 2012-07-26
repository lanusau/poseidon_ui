class UsersController < ApplicationController

  set_access_level :admin
  set_submenu :users

  # GET /user
  def index
    @users = User.all
  end

  # GET /user/new
  def new
    @user = User.new
  end

  # GET /user/1/edit
  def edit
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to users_path
  end

  # POST /user
  def create

    # Return to list if Cancel button is pressed
    redirect_to users_path and return if params[:commit] == "Cancel"

    @user = User.new(params[:user])

    @user.create_sysdate = DateTime.now()
    @user.update_sysdate = DateTime.now()
    
    if @user.save
      redirect_to users_path, :notice => 'Record created successfully'
    else
      render :action=>"new"
    end
  end

  # PUT /user/1
  def update

    # Return to list if Cancel button is pressed
    redirect_to users_path and return if params[:commit] == "Cancel"

    @user = User.find(params[:id])
    @user.attributes = params[:user]
    @user.update_sysdate = DateTime.now()


    if @user.save
      redirect_to users_path, :notice => 'Update successfull'
    else
      render :action=>"edit"
    end

  rescue ActiveRecord::RecordNotFound
    redirect_to users_path
  end

  # DELETE /user/1
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    redirect_to users_path, :notice => 'Delete successfull'

  rescue ActiveRecord::RecordNotFound
    redirect_to users_path
  end

end
