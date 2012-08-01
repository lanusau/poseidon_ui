class TargetGroupAssignment < ActiveRecord::Base
  attr_accessible :status_code, :inactive_until

  belongs_to :target_group
  belongs_to :target
  
  def inactive_until_str
    inactive_until.nil? ? "" : inactive_until.to_formatted_s(:untd_timestamp)
  end

end
