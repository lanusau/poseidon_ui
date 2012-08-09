class ScriptPersonNotification < ActiveRecord::Base
  attr_accessible :email_address

  belongs_to :script
  
  validates :email_address, :presence=>true
end
