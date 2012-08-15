class ScriptTargetRowLog < ActiveRecord::Base
  belongs_to :script_target_log

  has_many :script_target_col_logs

  # Return description of expression_result
  def expression_result_str
    case expression_result
      when 0 then "False"
      when 1 then "True"
      when 2 then "Error"
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
