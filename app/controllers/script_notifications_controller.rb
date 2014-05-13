class ScriptNotificationsController < ApplicationController

  set_access_level :user
  set_submenu :scripts

  # GET /scripts/:script_id/script_notifications
  def index
    @script = Script.find(params[:script_id])
    render :partial => "index"
  end

  # GET /scripts/:script_id/script_notifications/new
  def new
    @script = Script.find(params[:script_id])
    @notify_groups = NotifyGroup.all.order(:name)

    # Only leave records that are not assigned already
    @additional_notify_groups = Array.new
    @notify_groups.each do |notify_group|
      @additional_notify_groups.push(notify_group) unless @script.script_notifications.detect {|a| a.notify_group_id  == notify_group.id }
    end

    # Only JS format is supported, since this is AJAX call
    respond_to do |format|
      format.html { raise 'HTML request is not supported in this controller' }
      format.js
    end
  end

  # POST /scripts/:script_id/script_notifications
  def create
    @notify_group_id = params[:notify_group_id]
    @script = Script.find(params[:script_id])
    @script.script_notifications.create(
      :notify_group_id => @notify_group_id,
      :create_sysdate => DateTime.now(),
      :update_sysdate => DateTime.now()
    )
    # This will only be called via AJAX, so no need to render anything
    render :nothing => true

  end

  # DELETE /scripts/:script_id/script_notifications/:id
  def destroy
    @script_notification = ScriptNotification.find(params[:id])
    @script_notification.destroy
    @script = Script.find(params[:script_id])

    # Only JS format is supported, since this is AJAX call
    respond_to do |format|
      format.html { raise 'HTML request is not supported in this controller' }
      format.js
    end
  end
end
