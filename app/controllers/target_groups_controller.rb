class TargetGroupsController < ApplicationController

  set_access_level :user
  set_submenu :target_groups

  # GET /target_group
  def index
    @target_groups = TargetGroup.all.order(:name)
  end

  # GET /target_group/new
  def new
    @target_group = TargetGroup.new
  end

  # GET /target_group/1/edit
  def edit
    @target_group = TargetGroup.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to target_groups_path
  end

  # POST /target_group
  def create

    # Return to list if Cancel button is pressed
    redirect_to target_groups_path and return if params[:commit] == "Cancel"

    @target_group = TargetGroup.new(params[:target_group])

    @target_group.create_sysdate = DateTime.now()
    @target_group.update_sysdate = DateTime.now()


    if @target_group.save
      redirect_to target_groups_path, :notice => 'Record created successfully'
    else
      render :action=>"new"
    end
  end

  # PUT /target_group/1
  def update

    # Return to list if Cancel button is pressed
    redirect_to target_groups_path and return if params[:commit] == "Cancel"

    @target_group = TargetGroup.find(params[:id])
    @target_group.attributes = params[:target_group]
    @target_group.update_sysdate = DateTime.now()


    if @target_group.save
      redirect_to target_groups_path, :notice => 'Update successfull'
    else
      render :action=>"edit"
    end

  rescue ActiveRecord::RecordNotFound
    redirect_to target_groups_path
  end

  # DELETE /target_group/1
  def destroy
    @target_group = TargetGroup.find(params[:id])
    @target_group.destroy

    redirect_to target_groups_path, :notice => 'Delete successfull'

  rescue ActiveRecord::RecordNotFound
    redirect_to target_groups_path
  end
  
end
