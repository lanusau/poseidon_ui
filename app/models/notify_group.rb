class NotifyGroup < ActiveRecord::Base
  attr_accessible :name

  has_many :notify_group_emails,:order => "severity", :dependent => :delete_all
  
  validates :name,:presence=>true,
            :uniqueness => {:case_sensitive =>false, :message => "- duplicate name"}
  validates :create_sysdate, :presence=>true
  validates :update_sysdate, :presence=>true
end
