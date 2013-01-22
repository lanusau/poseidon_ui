class ScriptPersonNotification < ActiveRecord::Base
  attr_accessible :email_address

  belongs_to :script
  
  validates :email_address, :presence=>true

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
