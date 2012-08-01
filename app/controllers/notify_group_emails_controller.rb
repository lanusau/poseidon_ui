class NotifyGroupEmailsController < ApplicationController

  set_access_level :user
  set_submenu :notifications

  # GET /notify_groups/:notify_group_id/notify_group_email
  def index
    @notify_group = NotifyGroup.find(params[:notify_group_id])
    @notify_group_emails = @notify_group.notify_group_emails
  end

  # GET /notify_groups/:notify_group_id/notify_group_email/new
  def new
    @notify_group = NotifyGroup.find(params[:notify_group_id])
    @notify_group_email = NotifyGroupEmail.new
    @notify_group_email.notify_group = @notify_group
  end

  # POST /notify_groups/:notify_group_id/notify_group_email
  def create

    # Return to list if Cancel button is pressed
    @notify_group = NotifyGroup.find(params[:notify_group_id])
    redirect_to notify_group_emails_path(@notify_group) and return if params[:commit] == "Cancel"

    @notify_group_email = NotifyGroupEmail.new(params[:notify_group_email])
    @notify_group_email.notify_group = @notify_group

    @notify_group_email.create_sysdate = DateTime.now()
    @notify_group_email.update_sysdate = DateTime.now()


    if @notify_group_email.save
      redirect_to notify_group_emails_path(@notify_group), :notice => 'Record created successfully'
    else
      render :action=>"new"
    end
  end

  # DELETE /notify_groups/:notify_group_id/notify_group_email/1
  def destroy
    @notify_group = NotifyGroup.find(params[:notify_group_id])
    @notify_group_email = NotifyGroupEmail.find(params[:id])
    @notify_group_email.destroy

    redirect_to notify_group_emails_path(@notify_group), :notice => 'Delete successfull'

  rescue ActiveRecord::RecordNotFound
    redirect_to notify_group_emails_path(@notify_group)
  end
end
