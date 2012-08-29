class TargetHostname < ActiveRecord::Base
  attr_accessible :hostname

  belongs_to :target

  validates :hostname,:presence=>true,
            :uniqueness => {
              :scope=>"target_id",
              :case_sensitive =>false,
              :message => "- already exists for this target"}
            
  before_save :set_update_sysdate
  before_create :set_create_sysdate

  # Set create and update dates automatically
  def set_update_sysdate
    self.update_sysdate = DateTime.now()
  end
  def set_create_sysdate
    self.create_sysdate = DateTime.now()
  end

end
