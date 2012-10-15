class ScriptTargetLog < ActiveRecord::Base
  belongs_to :script_log
  belongs_to :target

  has_many :script_target_row_logs, :dependent => :destroy

  # Return description of status number
  def status_number_str(&block)
    case status_number
	   when 0 then "Running"
	   when 1 then
	     str_value = "Error"
         block == nil ? str_value : block.call(str_value)
	   when 2 then
	     str_value = "Finished"
         block == nil ? str_value : block.call(str_value)
	   when 3 then
	     str_value = "Alert triggered"
         block == nil ? str_value : block.call(str_value)
	   when 4 then
	     str_value = "Not triggered"
         block == nil ? str_value : block.call(str_value)
    end
  end

  # Return description of severity
  def severity_str
    return "" if severity.nil?
    case severity
      when 3 then "Low"
      when 2 then "Medium"
      when 1 then "High"
    end
  end
end
