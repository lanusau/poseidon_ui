class TargetGroupAssignment < ActiveRecord::Base
  attr_accessible :status_code, :inactive_until

  belongs_to :target_group
  belongs_to :target
  
end
