class ScriptPersonNotificationsController < ApplicationController

  set_access_level :user
  set_submenu :scripts

  # GET /scripts/:script_id/script_person_notifications
  def index
    @script = Script.find(params[:script_id])
    render :partial => "index"
  end

  # GET /scripts/:script_id/script_person_notifications/new
  def new
    @script = Script.find(params[:script_id])
    @script_person_notification = ScriptPersonNotification.new

    # Only JS format is supported, since this is AJAX call
    respond_to do |format|
      format.html { raise 'HTML request is not supported in this controller' }
      format.js
    end
  end

  # POST /scripts/:script_id/script_person_notifications
  def create

    @script = Script.find(params[:script_id])
    @script_person_notification = ScriptPersonNotification.new(params[:script_person_notification])

    @script_person_notification.script = @script

    @script_person_notification.create_sysdate = DateTime.now()
    @script_person_notification.update_sysdate = DateTime.now()
    @script_person_notification.save

    # This will only be called via AJAX, so no need to render anything
    render :nothing => true

  end

  # DELETE /scripts/:script_id/script_person_notifications/:id
  def destroy
    @script_person_notification = ScriptPersonNotification.find(params[:id])
    @script_person_notification.destroy
    @script = Script.find(params[:script_id])

    # Only JS format is supported, since this is AJAX call
    respond_to do |format|
      format.html { raise 'HTML request is not supported in this controller' }
      format.js
    end
  end
end
