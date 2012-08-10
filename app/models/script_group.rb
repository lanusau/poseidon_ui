class ScriptGroup < ActiveRecord::Base
  attr_accessible :target_group_id,:create_sysdate, :update_sysdate

  belongs_to :script
  belongs_to :target_group

  validates :target_group_id,:presence=>true,
            :uniqueness => {
              :scope=>"script_id",
              :message => "- already assigned for this script"}
  validates :script_id, :presence=>true
end
