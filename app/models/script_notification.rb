class ScriptNotification < ActiveRecord::Base
  attr_accessible :notify_group_id,:create_sysdate, :update_sysdate

  belongs_to :script
  belongs_to :notify_group

  validates :notify_group_id,:presence=>true,
            :uniqueness => {
              :scope=>"script_id",
              :message => "- already assigned for this script"}

  before_save :set_update_sysdate
  before_create :set_create_sysdate

  private

  # Set create and update dates automatically
  def set_update_sysdate
    self.update_sysdate = DateTime.now()
  end
  def set_create_sysdate
    self.create_sysdate = DateTime.now()
  end
end
