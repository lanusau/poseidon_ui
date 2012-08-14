require 'query_test'

class QueryColumnsController < ApplicationController

  set_access_level :user
  set_submenu :scripts

  # GET /scripts/:script_id/query_columns
  def index
    @script = Script.find(params[:script_id])
    render :partial => "index"
  end

  # POST /scripts/:script_id/query_columns
  def create
    @script = Script.find(params[:script_id])
    query_text = params[:script][:query_text]
    query_type = params[:script][:query_type]
    query_timeout = params[:script][:timeout_sec].to_i
    query_timeout = 3 if query_timeout < 1 or query_timeout > 1000

    # Try to find any target for this script
    target = @script.get_first_target

    if target == nil
      @error = "Please define at least 1 target or target group"
    else
      # Test query
      url = ((target.target_type.url_ruby.sub("%h",target.hostname)).sub("%p",target.port_number.to_s)).sub("%d",target.database_name)
      @query_tester = QueryTest.new(url,target.monitor_username,target.monitor_password,
        query_text,query_type,query_timeout)

      @query_tester.test

      if @query_tester.error then
        @error = @query_tester.error
      else
        @script.query_columns.clear
        @query_tester.column_names.each_with_index do | c,i |
          query_column = QueryColumn.new do |qc|
            qc.column_position = i
            qc.column_name_str = c
            qc.create_sysdate = DateTime.now()
            qc.update_sysdate = DateTime.now()
          end
          @script.query_columns<< query_column
        end
      end
    end
    render :partial => "index"
  end

end
