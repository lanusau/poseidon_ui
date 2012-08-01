class NotifyGroupsController < ApplicationController

  set_access_level :user
  set_submenu :notifications

  # GET /notify_group
  def index
    @notify_groups = NotifyGroup.all
  end

  # GET /notify_group/new
  def new
    @notify_group = NotifyGroup.new
  end

  # GET /notify_group/1/edit
  def edit
    @notify_group = NotifyGroup.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to notify_groups_path
  end

  # POST /notify_group
  def create

    # Return to list if Cancel button is pressed
    redirect_to notify_groups_path and return if params[:commit] == "Cancel"

    @notify_group = NotifyGroup.new(params[:notify_group])

    @notify_group.create_sysdate = DateTime.now()
    @notify_group.update_sysdate = DateTime.now()


    if @notify_group.save
      redirect_to notify_groups_path, :notice => 'Record created successfully'
    else
      render :action=>"new"
    end
  end

  # PUT /notify_group/1
  def update

    # Return to list if Cancel button is pressed
    redirect_to notify_groups_path and return if params[:commit] == "Cancel"

    @notify_group = NotifyGroup.find(params[:id])
    @notify_group.attributes = params[:notify_group]
    @notify_group.update_sysdate = DateTime.now()


    if @notify_group.save
      redirect_to notify_groups_path, :notice => 'Update successfull'
    else
      render :action=>"edit"
    end

  rescue ActiveRecord::RecordNotFound
    redirect_to notify_groups_path
  end

  # DELETE /notify_group/1
  def destroy
    @notify_group = NotifyGroup.find(params[:id])
    @notify_group.destroy

    redirect_to notify_groups_path, :notice => 'Delete successfull'

  rescue ActiveRecord::RecordNotFound
    redirect_to notify_groups_path
  end
end
