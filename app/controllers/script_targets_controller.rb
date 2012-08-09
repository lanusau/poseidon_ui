class ScriptTargetsController < ApplicationController

  set_access_level :user
  set_submenu :scripts

  # GET /scripts/:script_id/script_targets
  def index
    @script = Script.find(params[:script_id])
    render :partial => "index"
  end

  # GET /scripts/:script_id/script_targets/new
  def new
    @script = Script.find(params[:script_id])
    @targets = Target.all

    # Only leave records that are not assigned already
    @additional_targets = Array.new
    @targets.each do |target|
      @additional_targets.push(target) unless @script.script_targets.detect {|a| a.target_id  == target.id }
    end

    # Only JS format is supported, since this is AJAX call
    respond_to do |format|
      format.html { raise 'HTML request is not supported in this controller' }
      format.js
    end
  end

  # POST /scripts/:script_id/script_targets
  def create    
    @target_id = params[:target_id]
    @script = Script.find(params[:script_id])
    @script.script_targets.create(
      :target_id => @target_id,
      :create_sysdate => DateTime.now(),
      :update_sysdate => DateTime.now()
    )
    # This will only be called via AJAX, so no need to render anything
    render :nothing => true

  end

  # DELETE /scripts/:script_id/script_targets/:id
  def destroy
    @script_target = ScriptTarget.find(params[:id])
    @script_target.destroy
    @script = Script.find(params[:script_id])

    # Only JS format is supported, since this is AJAX call
    respond_to do |format|
      format.html { raise 'HTML request is not supported in this controller' }
      format.js
    end
  end

end
