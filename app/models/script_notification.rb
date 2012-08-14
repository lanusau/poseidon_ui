class ScriptNotification < ActiveRecord::Base
  attr_accessible :notify_group_id,:create_sysdate, :update_sysdate

  belongs_to :script
  belongs_to :notify_group

  validates :notify_group_id,:presence=>true,
            :uniqueness => {
              :scope=>"script_id",
              :message => "- already assigned for this script"}
  validates :script_id, :presence=>true
end
