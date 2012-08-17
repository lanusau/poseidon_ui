class TargetsController < ApplicationController

  set_access_level :user
  set_submenu :targets

  # GET /targets/reset
  def reset
    # Just reset session variables and redirect to index
    session.delete(:targets_page)
    session.delete(:target_name)
    redirect_to targets_path
  end

  # GET /targets
  def index

    session[:targets_page] = params[:page] if params[:page]
    session[:target_name] = params[:target_name] if params[:target_name]

    @target_name = session[:target_name]

    # Build an array of various conditions
    conditions = Array.new
    binds = Array.new

    # Filter on target name
    if !@target_name.blank?
      conditions << %Q[name like ?]
      binds << "%#{@target_name}%"
    end

    if conditions.size > 0
      @targets = Target.paginate(:page => session[:targets_page],:order=>"name",
      :conditions => [conditions.join(" AND "),binds].flatten)
    else
      @targets = Target.paginate(:page => session[:targets_page],:order=>"name")
    end
    
    # If this is an Ajax request (search), render partial template
    if (request.xhr?)
      render :partial =>"list" and return
    end

  end

  # GET /target/new
  def new
    @target_types = TargetType.all
    @servers = Server.all
    @target = Target.new
    @target.status_code = "A"
  end

  # GET /target/1/edit
  def edit
    @target_types = TargetType.all
    @servers = Server.all
    @target = Target.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to targets_path
  end

  # POST /target
  def create

    # Return to list if Cancel button is pressed
    redirect_to targets_path and return if params[:commit] == "Cancel"

    @target = Target.new(params[:target])

    @target.create_sysdate = DateTime.now()
    @target.update_sysdate = DateTime.now()


    if @target.save
      redirect_to targets_path, :notice => 'Record created successfully'
    else
      @target_types = TargetType.all
      @servers = Server.all
      render :action=>"new"
    end
  end

  # PUT /target/1
  def update

    # Return to list if Cancel button is pressed
    redirect_to targets_path and return if params[:commit] == "Cancel"

    @target = Target.find(params[:id])

    attributes = params[:target]
    # If monitoring password was not set to anything, ignore it
    if attributes[:monitor_password].blank?
      attributes.delete(:monitor_password)
    end

    @target.attributes = attributes
    @target.update_sysdate = DateTime.now()


    if @target.save
      redirect_to targets_path, :notice => 'Update successfull'
    else
      @target_types = TargetType.all
      @servers = Server.all
      render :action=>"edit"
    end

  rescue ActiveRecord::RecordNotFound
    redirect_to targets_path
  end

  # DELETE /target/1
  def destroy
    @target = Target.find(params[:id])
    @target.destroy

    redirect_to targets_path, :notice => 'Delete successfull'

  rescue ActiveRecord::RecordNotFound
    redirect_to targets_path
  end

  # Activate target
  #  POST   /targets/:id/activate
  def activate
    @target = Target.find(params[:id])
    @target.status_code = 'A'
    @target.save
    
    # Only render JS template
    respond_to do |format|
      format.js
    end
    
  end

  # Inactivate target
  # POST   /targets/:id/inactivate
  def inactivate
    @target = Target.find(params[:id])

    hours = params[:hours].to_i
    hours = 24 if hours.nil?

    @target.status_code = 'I'
    @target.inactive_until = DateTime.now().advance :hours => hours
    @target.save

    # Only render JS template
    respond_to do |format|
      format.js {render "activate"}
    end
  end
end
