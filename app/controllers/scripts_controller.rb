require 'query_test'
require 'timeout'

class ScriptsController < ApplicationController

  set_access_level :user
  set_submenu :scripts

  # GET /scripts/reset
  def reset
    # Just reset session variables and redirect to index
    session.delete(:page)
    session.delete(:script_search_name)
    session.delete(:script_category_id)
    
    redirect_to scripts_path
  end

  # GET /scripts
  def index

    session[:page] = params[:page] if params[:page]
    session[:script_search_name] = params[:script_search_name] if params[:script_search_name]
    session[:script_category_id] = params[:script_category_id] if params[:script_category_id]

    @script_search_name = session[:script_search_name]
    @script_category_id = session[:script_category_id]

    # Build an array of various conditions
    conditions = Array.new
    binds = Array.new

    # Filter on script name
    if !@script_search_name.blank?
      conditions << %Q[name like ?]
      binds << "%#{@script_search_name}%"
    end

    if @script_category_id &&  @script_category_id.downcase.to_sym != :all
      conditions << %q{exists (select * from psd_script_category_assign a
                                 where a.script_id = psd_script.script_id
                                 and a.script_category_id = ?)}
      binds << @script_category_id
    end

    if conditions.size > 0
      @scripts = Script.paginate(:page => session[:page],:order=>"name",
      :conditions => [conditions.join(" AND "),binds].flatten)
    else
      @scripts = Script.paginate(:page => session[:page],:order=>"name")
    end

    @script_categories = ScriptCategory.all        

    # If this is an Ajax request (search), render partial template
    if (request.xhr?)
      render :partial =>"list" and return
    end

  end

  # GET /script/new
  def new
    @script = Script.new(
      :query_type => 1,
      :fixed_severity => 1,
      :schedule_min => "0",
      :schedule_hour => "*",
      :schedule_day => "*",
      :schedule_month => "*",
      :schedule_week => "?",
      :timeout_sec => 300,
      :status_code => "A"
    )
  end

  # GET /script/1/edit
  def edit
    @script = Script.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to scripts_path
  end

  # POST /script
  def create

    # Return to list if Cancel button is pressed
    redirect_to scripts_path and return if params[:commit] == "Cancel"

    @script = Script.new(params[:script])

    @script.create_sysdate = DateTime.now()
    @script.update_sysdate = DateTime.now()


    if @script.save
      redirect_to edit_script_path(@script), :notice => 'Record created successfully'
    else
      render :action=>"new"
    end
  end

  # PUT /script/1
  def update

    # Return to list if Cancel button is pressed
    redirect_to scripts_path and return if params[:commit] == "Cancel"

    @script = Script.find(params[:id])

    @script.attributes = params[:script]
    @script.update_sysdate = DateTime.now()


    if @script.save
      redirect_to scripts_path, :notice => 'Update successfull'
    else
      render :action=>"edit"
    end

  rescue ActiveRecord::RecordNotFound
    redirect_to scripts_path
  end

  # DELETE /script/1
  def destroy
    @script = Script.find(params[:id])
    @script.destroy

    redirect_to scripts_path, :notice => 'Delete successfull'

  rescue ActiveRecord::RecordNotFound
    redirect_to scripts_path
  end

  # POST /scripts/:id/activate
  def activate
    @script = Script.find(params[:id])
    @script.status_code = 'A'
    @script.save

    # Only render JS template
    respond_to do |format|
      format.js
    end

  end

  # POST /scripts/:id/inactivate
  def inactivate
    @script = Script.find(params[:id])
    @script.status_code = 'I'
    @script.save

    # Only render JS template
    respond_to do |format|
      format.js {render "activate"}
    end
  end

  # POST /scripts/:id/test
  def test
    script = Script.find(params[:id])
    query_text = params[:script][:query_text]
    query_type = params[:script][:query_type]
    query_timeout = params[:script][:timeout_sec].to_i
    query_timeout = 3 if query_timeout < 1 or query_timeout > 1000

    # Try to find any target for this script
    target = get_first_target(script)

    if target == nil
      @error = "Please define at least 1 target or target group"
    else
      # Test query
      url = ((target.target_type.url_ruby.sub("%h",target.hostname)).sub("%p",target.port_number.to_s)).sub("%d",target.database_name)
      @sql_tester = QueryTest.new(url,target.monitor_username,target.monitor_password,query_text,query_type)
      
      begin
        Timeout::timeout(query_timeout) {
          @sql_tester.test
        }
      rescue Timeout::Error => e
        @error = %q{Query timed out. This can be caused by long query but also
                   can be caused by server not being to connect to target (maybe
                   there is a firewall involved ?)}
      rescue Exception => e
        @error = "Error:#{e.message}"
      end
    end
    render :partial=>"test"
  end

  private

  # Get first assigned target for the particular script
  def get_first_target(script)

    if script.script_targets.empty? && script.script_groups.empty?
      return nil
    else
      if ! script.script_targets.empty?
        target = script.script_targets[0].target
      elsif ! script.script_groups.empty?
        target = script.script_groups[0].target_group.target_group_assignments[0].target
      end
    end

    return target

  end

end
