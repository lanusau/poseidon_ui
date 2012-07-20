class User < ActiveRecord::Base
  attr_accessible :login, :password, :password_confirmation,:access_level
  has_secure_password

  validates :login,:presence=>true,
            :uniqueness => {:case_sensitive =>false, :message => "- duplicate login"}
  validates :access_level, :presence=>true,:numericality => true, :inclusion => { :in => 0..9 }
  validates :create_sysdate, :presence=>true
  validates :update_sysdate, :presence=>true
  
end
