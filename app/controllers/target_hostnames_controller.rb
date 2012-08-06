class TargetHostnamesController < ApplicationController

  set_access_level :user
  set_submenu :targets

  # GET /targets/:target_id/target_hostname
  def index
    @target = Target.find(params[:target_id])
    @target_hostnames = @target.target_hostnames
    render :layout =>"iframe"
  end

  # GET /targets/:target_id/target_hostname/new
  def new
    @target = Target.find(params[:target_id])
    @target_hostname = TargetHostname.new
    @target_hostname.target = @target
    render :layout =>"iframe"
  end

  # POST /targets/:target_id/target_hostname
  def create

    # Return to list if Cancel button is pressed
    @target = Target.find(params[:target_id])
    redirect_to target_hostnames_path(@target) and return if params[:commit] == "Cancel"

    @target_hostname = TargetHostname.new(params[:target_hostname])
    @target_hostname.target = @target

    @target_hostname.create_sysdate = DateTime.now()
    @target_hostname.update_sysdate = DateTime.now()


    if @target_hostname.save
      redirect_to target_hostnames_path(@target), :notice => 'Record created successfully'
    else
      render :action=>"new", :layout =>"iframe"
    end
  end

  # DELETE /targets/:target_id/target_hostname/1
  def destroy
    @target = Target.find(params[:target_id])
    @target_hostname = TargetHostname.find(params[:id])
    @target_hostname.destroy

    redirect_to target_hostnames_path(@target), :notice => 'Delete successfull'

  rescue ActiveRecord::RecordNotFound
    redirect_to target_hostnames_path(@target)
  end
end
