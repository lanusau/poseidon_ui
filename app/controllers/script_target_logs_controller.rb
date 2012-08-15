class ScriptTargetLogsController < ApplicationController

  set_access_level :user
  set_submenu :script_logs

  # GET    /script_logs/:script_log_id/script_target_logs
  def index
    @script_log = ScriptLog.find(params[:script_log_id])
  end

end
