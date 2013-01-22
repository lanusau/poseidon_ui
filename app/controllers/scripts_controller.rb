require 'query_test'

class ScriptsController < ApplicationController

  set_access_level :user
  set_submenu :scripts

  # GET /scripts/reset
  def reset
    # Just reset session variables and redirect to index
    session.delete(:scripts_page)
    session.delete(:script_search_name)
    session.delete(:script_category_id)
    session.delete(:target_id)
    
    redirect_to scripts_path
  end

  # GET /scripts
  # GET /targets/:target_id/scripts
  def index

    session[:scripts_page] = params[:page] if params[:page]
    session[:script_search_name] = params[:script_search_name] if params[:script_search_name]
    session[:script_category_id] = params[:script_category_id] if params[:script_category_id]
    session[:target_id] = params[:target_id] if params[:target_id]

    @script_search_name = session[:script_search_name]
    @script_category_id = session[:script_category_id]
    @target_id = session[:target_id]

    # Build an array of various conditions
    conditions = Array.new
    binds = Array.new

    # Filter on script name
    if !@script_search_name.blank?
      conditions << %Q[name like ?]
      binds << "%#{@script_search_name}%"
    end

    # Filter on script category
    if @script_category_id &&  @script_category_id.downcase.to_sym != :all
      conditions << %q{exists (select * from psd_script_category_assign a
                                 where a.script_id = psd_script.script_id
                                 and a.script_category_id = ?)}
      binds << @script_category_id
    end

    # Filter on particular target,
    # directly or through target groups
    if @target_id.present?
      begin
        @target = Target.find(@target_id)
        conditions << %q{
          ( exists ( select * from psd_script_target t
                     where t.script_id = psd_script.script_id
                     and t.target_id = ?
                   )
            or
            exists ( select *
                     from psd_script_group g, psd_target_group_assignment a
                     where g.script_id = psd_script.script_id
                     and g.target_group_id = a.target_group_id
                     and a.target_id = ?
                   )
          )
        }
        # 2 binds, the same target_id in both
        binds << @target_id
        binds << @target_id
      rescue Exception => e
        @target_id = ""
      end
    end    

    if conditions.size > 0
      @scripts = Script.paginate(:page => session[:scripts_page],:order=>"name",
      :conditions => [conditions.join(" AND "),binds].flatten,
      :include => {:script_category_assigns => :script_category})
    else
      @scripts = Script.paginate(:page => session[:scripts_page],:order=>"name",
      :include => {:script_category_assigns => :script_category})
    end

    @script_categories = ScriptCategory.all(:order => "name")

    # If this is an Ajax request (search), render partial template
    if (request.xhr?)
      render :partial =>"list" and return
    end

  end

  # GET /script/new"#{
  def new
    @script = Script.new
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
    @script.status_code = 'I'
    @script.query_type = 1
    @script.fixed_severity = 1
    @script.schedule_min = "0"
    @script.schedule_hour = "*"
    @script.schedule_day = "*"
    @script.schedule_month = "*"
    @script.schedule_week = "?"
    @script.timeout_sec = 300

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

  # GET    /scripts/:id/clone
  def clone
    @original_script = Script.find(params[:id])
    @script = Script.new
  rescue ActiveRecord::RecordNotFound
    redirect_to scripts_path
  end

  # POST   /scripts/:id/clone_create
  def clone_create
    @original_script = Script.find(params[:id])
    @script = @original_script.clone_script
    @script.attributes = params[:script]
    @script.create_sysdate = DateTime.now()
    @script.update_sysdate = DateTime.now()

    if @script.save
      redirect_to edit_script_path(@script), :notice => 'Clone successfull'
    else
      render :action=>"clone"
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to scripts_path
  end

  # POST /scripts/:id/test_query
  def test_query
    script = Script.find(params[:id])
    query_text = params[:script][:query_text]
    query_type = params[:script][:query_type]
    query_timeout = params[:script][:timeout_sec].to_i
    query_timeout = 3 if query_timeout < 1 or query_timeout > 1000

    # Try to find any target for this script
    target = script.get_first_target

    if target == nil
      @error = "Please define at least 1 target or target group"
    else
      # Test query
      url = ((target.target_type.url_ruby.sub("%h",target.hostname)).sub("%p",target.port_number.to_s)).sub("%d",target.database_name)
      @query_tester = QueryTest.new(url,target.monitor_username,target.monitor_password,
        query_text,query_type,query_timeout)

      @query_tester.test

    end

    render :partial=>"test_query"
  end

  # POST /scripts/:id/test_expression
  def test_expression
    script = Script.find(params["id"])
    expression_text = params["script"]["expression_text"]
    query_text = params["script"]["query_text"]
    query_type = params["script"]["query_type"]
    query_timeout = params[:script][:timeout_sec].to_i
    query_timeout = 3 if query_timeout < 1 or query_timeout > 1000

    # Get first script target and build query tester object
    target = script.get_first_target

    if target == nil
      @error = "Please define at least 1 target or target group"
    else
      url = ((target.target_type.url_ruby.sub("%h",target.hostname)).sub("%p",target.port_number.to_s)).sub("%d",target.database_name)
      @query_tester = QueryTest.new(url,target.monitor_username,target.monitor_password,
        query_text,query_type,query_timeout)

      # Run query test, which will build a list of columns
      @query_tester.test

      if !@query_tester.error


        # Go through the every line in the result set and evaluate it, storing evaluation
        # results in the array
        @evaluation_results = Array.new

        @query_tester.result_set.each do |row|

          # Construct expressions by replacing $x variable in expression with column values
          evaluation_string = expression_text
          row.each_with_index do |col_value,index|
            evaluation_string = evaluation_string.gsub("%"<< index.to_s,col_value.to_s)
          end

          # Replace %rc with number of rows
          evaluation_string = evaluation_string.gsub("%rc",@query_tester.result_set.size.to_s)

          # Try to evaluate expression
          begin
            eval_result = eval(evaluation_string)
          rescue Exception => e
            eval_result = e.message
          end

          # Add evaluation result to the array
          @evaluation_results<< eval_result
        end
      end
    end

    render :partial=>"test_expression"

  end

  # GET /scripts/:id/test_message
  def test_message
    script = Script.find(params[:id])
    query_text = params[:script][:query_text]
    query_type = params[:script][:query_type]
    query_timeout = params[:script][:timeout_sec].to_i
    query_timeout = 3 if query_timeout < 1 or query_timeout > 1000
    message_format = params[:script][:message_format]
    message_subject = params[:script][:message_subject] || ""
    message_header = params[:script][:message_header] || ""
    message_text_str = params[:script][:message_text_str] || ""
    message_footer = params[:script][:message_footer] || ""


    # Get first script target and build query tester object
    target = script.get_first_target
    if target == nil
      @error = "Please define at least 1 target or target group"
    else

      url = ((target.target_type.url_ruby.sub("%h",target.hostname)).sub("%p",target.port_number.to_s)).sub("%d",target.database_name)
      @query_tester = QueryTest.new(url,target.monitor_username,target.monitor_password,
        query_text,query_type,query_timeout)

      # Run query test, which will build a list of columns
      @query_tester.test

      if !@query_tester.error

        @message_subject_str = (message_subject.gsub("%t",target.name)).gsub("%n",script.name).gsub("%s","High")
        @message_header_str = ((message_header.gsub("%t",target.name)).gsub("%n",script.name)).gsub("%rc",@query_tester.result_set.length.to_s)
        @message_footer_str = ((message_footer.gsub("%t",target.name)).gsub("%n",script.name)).gsub("%rc",@query_tester.result_set.length.to_s)
        @message_rows = Array.new
        @query_tester.result_set.each do |row|
          row_message = message_text_str
          row.each_with_index do |col_value,index|
            row_message = row_message.gsub("%"<< index.to_s,col_value.to_s)
          end
          @message_rows << row_message
        end
      else
        @error = @query_tester.error
      end
    end

    render "test_message", :layout => "iframe" and return if @error

    if message_format == "1" # HTML
      html_document = @message_header_str << @message_rows.join("\n") << @message_footer_str
      render :inline => "#{html_document}", :layout => false
    else
      render "test_message", :layout => "iframe"
    end
  end

end
