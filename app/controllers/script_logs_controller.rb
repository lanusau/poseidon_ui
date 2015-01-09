class ScriptLogsController < ApplicationController

  set_access_level :user
  set_submenu :script_logs

  # GET /script_logs/reset
  def reset
    # Just reset session variables and redirect to index
    session.delete(:script_logs_page)
    session.delete(:date_from)
    session.delete(:date_to)
    session.delete(:trigger_filter_code)
    session.delete(:error_filter_code)
    session.delete(:script_id)

    redirect_to script_logs_path
  end

  # GET    /script_logs
  # GET    /scripts/:script_id/script_logs
  def index
    session[:script_logs_page] = params[:page] if params[:page]
    session[:date_from] = params[:date_from] if params[:date_from]
    session[:date_to] = params[:date_to] if params[:date_to]
    session[:trigger_filter_code] = params[:trigger_filter_code] if params[:trigger_filter_code]
    session[:error_filter_code] = params[:error_filter_code] if params[:error_filter_code]
    session[:script_id] = params[:script_id] if params[:script_id]

    @date_from = session[:date_from]
    @date_to = session[:date_to]
    @trigger_filter_code = session[:trigger_filter_code]
    @error_filter_code = session[:error_filter_code]
    @script_id = session[:script_id]

    @trigger_filter_code = :all if @trigger_filter_code.present? and @trigger_filter_code.downcase.to_sym == :all
    @error_filter_code = :all if @error_filter_code.present? and @error_filter_code.downcase.to_sym == :all

    # Build an array of various conditions
    conditions = Array.new
    binds = Array.new

    # Filter by script
    if @script_id.present?
      begin
        @script = Script.find(@script_id)
        # For performance reasons we will not look past 7 days
        conditions << %Q[script_id = ?]
        binds << @script.id
      rescue Exception 
        @script_id = ""
      end
    end

    date_filter_set = false

    # Filter on start_date
    if @date_from.present?
      if @date_from =~ /\d{2}-\d{2}-\d{4}\s\d{2}:\d{2}:\d{2}/
        conditions << %Q[start_date >= STR_TO_DATE(?,'%m-%d-%Y %H:%i:%s')]
        binds << @date_from
        date_filter_set = true
      else
        flash[:notice] = "Invalid date format, please use format MM-DD-YYYY HH24:MI:SS"
      end
    end
    if @date_to.present?
      if @date_to =~ /\d{2}-\d{2}-\d{4}\s\d{2}:\d{2}:\d{2}/
        conditions << %Q[start_date < STR_TO_DATE(?,'%m-%d-%Y %H:%i:%s')]
        binds << @date_to
        date_filter_set = true
      else
        flash[:notice] = "Invalid date format, please use format MM-DD-YYYY HH24:MI:SS"
      end
    end
    # Filter on trigger status code
    if @trigger_filter_code.present? && @trigger_filter_code != :all
      conditions << %Q[trigger_status_code = ?]
      binds << @trigger_filter_code
    end
    # Filter on error status code
    if @error_filter_code.present? && @error_filter_code != :all
      conditions << %Q[error_status_code = ?]
      binds << @error_filter_code
    end

    # If we don't have filter on start_date, add it to only show rows for last
    # X days.
    unless date_filter_set
      conditions << %Q[start_date > date_sub(now(),INTERVAL ? day)]
      binds << 7
    end

    # Paginate
    @script_logs = ScriptLog.where([conditions.join(" AND "),binds].flatten).
      order('start_date desc').
      includes([:script,:server]).
      paginate(:page => session[:script_logs_page])

  end
end
