class User < ActiveRecord::Base

  # Define access level mapping for user access levels
  @@access_level_map = {
    0 => {:name=>:admin,:label=>"Admin"},
    1 => {:name=>:user,:label=>"User"},
    5 => {:name=>:op,:label=>"OpsDB"},    
    9 => {:name=>:guest,:label=>"Guest"}
  }

  attr_accessible :login, :password, :password_confirmation,:access_level
  has_secure_password

  validates :login,:presence=>true,
            :uniqueness => {:case_sensitive =>false, :message => "- duplicate login"}
  validates :access_level, :presence=>true,:numericality => true, :inclusion => { :in => 0..9 }
  validates :create_sysdate, :presence=>true
  validates :update_sysdate, :presence=>true

  # Return readable value of access level
  def access_level_str
    return @@access_level_map[access_level][:label]
  end

  # Class method to find access level value based on name
  def User.access_level_lookup(name)
    @@access_level_map.each{|key,value| return key if value[:name] == name}
    return nil
  end

end
