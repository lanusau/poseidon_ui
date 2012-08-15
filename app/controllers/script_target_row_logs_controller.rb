class ScriptTargetRowLogsController < ApplicationController

  set_access_level :user
  set_submenu :script_logs

  # GET /script_target_logs/:script_target_log_id/script_target_row_logs
  def index
    @script_target_log = ScriptTargetLog.find(params[:script_target_log_id])
  end

end
