class ScriptLogsController < ApplicationController

  set_access_level :user
  set_submenu :script_logs

  # GET /script_logs/reset
  def reset
    # Just reset session variables and redirect to index
    session.delete(:page)
    session.delete(:date_from)
    session.delete(:date_to)
    session.delete(:trigger_filter_code)
    session.delete(:error_filter_code)

    redirect_to script_logs_path
  end

  # GET    /script_logs/filter
  def filter
    # Need to reset page number when running new filter
    session.delete(:page)
    # Just forward to index with the same parameters (without action)
    params.delete(:action)
    redirect_to script_logs_path(params)
  end
  
  # GET    /script_logs
  def index
    session[:page] = params[:page] if params[:page]
    session[:date_from] = params[:date_from] if params[:date_from]
    session[:date_to] = params[:date_to] if params[:date_to]
    session[:trigger_filter_code] = params[:trigger_filter_code] if params[:trigger_filter_code]
    session[:error_filter_code] = params[:error_filter_code] if params[:error_filter_code]

    @date_from = session[:date_from]
    @date_to = session[:date_to]
    @trigger_filter_code = session[:trigger_filter_code]
    @error_filter_code = session[:error_filter_code]

    @trigger_filter_code = :all if @trigger_filter_code.present? and @trigger_filter_code.downcase.to_sym == :all
    @error_filter_code = :all if @error_filter_code.present? and @error_filter_code.downcase.to_sym == :all

    # Build an array of various conditions
    conditions = Array.new
    binds = Array.new

    # Filter on start_date
    if @date_from.present?
      if @date_from =~ /\d{2}-\d{2}-\d{4}\s\d{2}:\d{2}:\d{2}/
        conditions << %Q[start_date >= STR_TO_DATE(?,'%m-%d-%Y %H:%i:%s')]
        binds << @date_from
      else
        flash[:notice] = "Invalid date format, please use format MM-DD-YYYY HH24:MI:SS"
      end
    end
    # Filter on finish_date
    if @date_to.present?
      if @date_to =~ /\d{2}-\d{2}-\d{4}\s\d{2}:\d{2}:\d{2}/
        conditions << %Q[finish_date < STR_TO_DATE(?,'%m-%d-%Y %H:%i:%s')]
        binds << @date_to
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

    # Paginate
    if conditions.size > 0
      @script_logs = ScriptLog.paginate(:page => session[:page],:order=>"start_date desc",:include =>:script,
      :conditions => [conditions.join(" AND "),binds].flatten)
    else
      @script_logs = ScriptLog.paginate(:page => session[:page],:order=>"start_date desc",:include =>:script)
    end

  end
end
