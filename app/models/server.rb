class Server < ActiveRecord::Base
  attr_accessible :heartbeat_date, :location, :name, :status_code

  has_many :targets, :dependent => :delete_all

  validates :status_code, :presence=>true, :inclusion => {:in =>%w( A I)}
  validates :name,:presence=>true,
            :uniqueness => {:case_sensitive =>false, :message => "- duplicate name"}
  validates :create_sysdate, :presence=>true
  validates :update_sysdate, :presence=>true

end
