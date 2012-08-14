class NotifyGroupEmail < ActiveRecord::Base
  attr_accessible :email_address, :severity

  belongs_to :notify_group

  validates :notify_group_id, :presence=>true
  validates :severity, :numericality => true, :inclusion => { :in => 1..3 }
  validates :email_address, :presence=>true
  validates :create_sysdate, :presence=>true
  validates :update_sysdate, :presence=>true

  # Printable value of severity
  def severity_str
    case severity
    when 3 then "Low"
    when 2 then "Medium"
    when 1 then "High"
    end
  end
end
