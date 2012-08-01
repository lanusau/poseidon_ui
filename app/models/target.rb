class Target < ActiveRecord::Base
  attr_accessible :name, :hostname,:database_name,:port_number,
    :monitor_username,:monitor_password,:status_code,:inactive_until

  has_many :target_group_assignments, :dependent => :delete_all
  belongs_to :target_type
  belongs_to :server


  validates :name,:presence=>true,
            :uniqueness => {:case_sensitive =>false, :message => "- duplicate name"}
  validates :hostname, :presence=>true
  validates :database_name, :presence=>true
  validates :port_number, :presence=>true,:numericality => true
  validates :monitor_username, :presence=>true
  validates :monitor_password, :presence=>true
  validates :status_code, :presence=>true, :inclusion => {:in =>%w( A I)}
  validates :create_sysdate, :presence=>true
  validates :update_sysdate, :presence=>true    

  # Overwrite default accessor to provide custom date format
  def inactive_until
    self[:inactive_until].to_formatted_s(:untd_timestamp) unless self[:inactive_until] == nil
  end
end
