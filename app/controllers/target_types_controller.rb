class TargetTypesController < ApplicationController

  set_access_level :user
  set_submenu :target_types

  # GET /target_type
  def index
    @target_types = TargetType.all
  end

  # GET /target_type/new
  def new
    @target_type = TargetType.new
  end

  # GET /target_type/1/edit
  def edit
    @target_type = TargetType.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to target_types_path
  end

  # POST /target_type
  def create

    # Return to list if Cancel button is pressed
    redirect_to target_types_path and return if params[:commit] == "Cancel"

    @target_type = TargetType.new(params[:target_type])

    @target_type.create_sysdate = DateTime.now()
    @target_type.update_sysdate = DateTime.now()

    
    if @target_type.save
      redirect_to target_types_path, :notice => 'Record created successfully'
    else
      render :action=>"new"
    end
  end

  # PUT /target_type/1
  def update

    # Return to list if Cancel button is pressed
    redirect_to target_types_path and return if params[:commit] == "Cancel"

    @target_type = TargetType.find(params[:id])
    @target_type.attributes = params[:target_type]
    @target_type.update_sysdate = DateTime.now()


    if @target_type.save
      redirect_to target_types_path, :notice => 'Update successfull'
    else
      render :action=>"edit"
    end

  rescue ActiveRecord::RecordNotFound
    redirect_to target_types_path
  end

  # DELETE /target_type/1
  def destroy
    @target_type = TargetType.find(params[:id])
    @target_type.destroy

    redirect_to target_types_path, :notice => 'Delete successfull'

  rescue ActiveRecord::RecordNotFound
    redirect_to target_types_path
  end

end
