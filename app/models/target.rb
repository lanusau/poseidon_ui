class Target < ActiveRecord::Base
  attr_accessible :name, :hostname,:database_name,:port_number,
    :monitor_username,:monitor_password,:status_code,:inactive_until,
    :target_type_id, :server_id

  has_many :target_group_assignments, :dependent => :delete_all
  has_many :target_hostnames, :dependent => :delete_all
  has_many :script_target_logs
  has_many :script_targets, :dependent => :delete_all
  
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

  validate :validate_inactive_until

  # Validate inactive_until
  def validate_inactive_until
    errors.add(:inactive_until, "- invalid date format") unless
      inactive_until_before_type_cast.blank? ||
      inactive_until_before_type_cast.class != String ||
      inactive_until_before_type_cast =~ /\d{2}-\d{2}-\d{4}\s\d{2}:\d{2}:\d{2}/
  end

end
