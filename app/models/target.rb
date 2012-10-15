class Target < ActiveRecord::Base
  attr_accessible :name, :hostname,:database_name,:port_number,
    :monitor_username,:monitor_password,:status_code,:inactive_until,
    :target_type_id, :server_id, :target_hostnames_attributes

  has_many :target_group_assignments, :dependent => :delete_all
  has_many :target_hostnames, :dependent => :delete_all
  accepts_nested_attributes_for :target_hostnames, :allow_destroy => true, :reject_if => :all_blank
  has_many :script_target_logs, :dependent => :delete_all
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

  datetime_with_default_format :inactive_until, :allow_nil=>true

  # Accessors for encrypted password
  def monitor_password=(password)
    return if password.blank?

    # Regenerate salt each time password is changed
    salt = 16.times.map{Random.rand(10)}.join
    write_attribute(:salt,salt)

    secret_key = Digest::MD5.digest(ActiveRecord::Base.configurations[Rails.env]["secret"]||"m0nitr$this")
    iv = Digest::MD5.digest(salt)
    write_attribute(:monitor_password, Base64.encode64(Encryptor.encrypt(password, :key => secret_key,:iv=>iv)))
  end

  def monitor_password
    secret_key = Digest::MD5.digest(ActiveRecord::Base.configurations[Rails.env]["secret"]||"m0nitr$this")
    iv = Digest::MD5.digest(read_attribute(:salt))
    begin
    Encryptor.decrypt(Base64.decode64(read_attribute(:monitor_password)), :key => secret_key,:iv=>iv)
    rescue 
      return read_attribute(:monitor_password)
    end
  end

  # This can be used to re-encrypt passwords
  def monitor_password_with(secret,salt)
    secret_key = Digest::MD5.digest(secret)
    iv = Digest::MD5.digest(salt)
    begin
    Encryptor.decrypt(Base64.decode64(read_attribute(:monitor_password)), :key => secret_key,:iv=>iv)
    rescue
      return read_attribute(:monitor_password)
    end
  end

end
