class ServersController < ApplicationController

  # Allow only level 1 users
  before_filter {authorize(1)}

  # GET /server
  def index
    @servers = Server.all
  end

  # GET /server/new
  def new
    @server = Server.new
    @server.status_code = "A"
  end

  # GET /server/1/edit
  def edit
    @server = Server.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to servers_path
  end

  # POST /server
  def create

    # Return to list if Cancel button is pressed
    redirect_to servers_path and return if params[:commit] == "Cancel"

    @server = Server.new(params[:server])

    @server.create_sysdate = DateTime.now()
    @server.update_sysdate = DateTime.now()
    @server.heartbeat_sysdate = DateTime.now()

    
    if @server.save
      redirect_to servers_path, :notice => 'Record created successfully'
    else
      render :action=>"new"
    end    
  end

  # PUT /server/1
  def update

    # Return to list if Cancel button is pressed
    redirect_to servers_path and return if params[:commit] == "Cancel"

    @server = Server.find(params[:id])
    @server.attributes = params[:server]
    @server.update_sysdate = DateTime.now()


    if @server.save
      redirect_to servers_path, :notice => 'Update successfull'
    else
      render :action=>"edit"
    end

  rescue ActiveRecord::RecordNotFound
    redirect_to servers_path
  end

  # DELETE /server/1
  def destroy
    @server = Server.find(params[:id])
    @server.destroy
    
    redirect_to servers_path, :notice => 'Delete successfull'

  rescue ActiveRecord::RecordNotFound
    redirect_to servers_path
  end

end
