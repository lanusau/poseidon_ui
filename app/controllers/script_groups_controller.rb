class ScriptGroupsController < ApplicationController

  set_access_level :user
  set_submenu :scripts

  # GET /scripts/:script_id/script_groups
  def index
    @script = Script.find(params[:script_id])
    render :partial => "index"
  end

  # GET /scripts/:script_id/script_groups/new
  def new
    @script = Script.find(params[:script_id])
    @target_groups = TargetGroup.all(:order => "name")

    # Only leave records that are not assigned already
    @additional_groups = Array.new
    @target_groups.each do |group|
      @additional_groups.push(group) unless @script.script_groups.detect {|a| a.target_group_id  == group.id }
    end

    # Only JS format is supported, since this is AJAX call
    respond_to do |format|
      format.html { raise 'HTML request is not supported in this controller' }
      format.js
    end
  end

  # POST /scripts/:script_id/script_groups
  def create
    @target_group_id = params[:target_group_id]
    @script = Script.find(params[:script_id])
    @script.script_groups.create(
      :target_group_id => @target_group_id,
      :create_sysdate => DateTime.now(),
      :update_sysdate => DateTime.now()
    )
    # This will only be called via AJAX, so no need to render anything
    render :nothing => true

  end

  # DELETE /scripts/:script_id/script_groups/:id
  def destroy
    @script_group = ScriptGroup.find(params[:id])
    @script_group.destroy
    @script = Script.find(params[:script_id])

    # Only JS format is supported, since this is AJAX call
    respond_to do |format|
      format.html { raise 'HTML request is not supported in this controller' }
      format.js
    end
  end
end
