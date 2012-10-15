class ScriptLog < ActiveRecord::Base
  belongs_to :script
  has_many :script_target_logs, :dependent => :destroy

  # Printable value of status number
  def status_number_str(&block)
    case status_number
        when 0 then "Started"
        when 2 then
          str_value = "Finished"
          block == nil ? str_value : block.call(str_value)
        when 5 then "Missfired"
        when 6 then
          str_value = "Timed out"
          block == nil ? str_value : block.call(str_value)
        else "Unknown"
    end
  end

  # Printable value of status code
  def trigger_status_code_str
    case trigger_status_code
      when 0 then ""
      when 1 then "Triggered"
    end
  end

  # Printable value of error status code
  def error_status_code_str
    case error_status_code
      when 0 then ""
      when 1 then "Error"
    end  
  end
end
