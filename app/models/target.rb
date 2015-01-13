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

  # Purge child records in nested form that are marked for deletion
  before_save :purge_nested_form

  # Validate records in nested form
  validate :validate_nested_form

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

  # Delete child objects marked for destruction first
  # This fixes duplicate key issue when record in nested form is removed and
  # then added again.
  def purge_nested_form
    self.target_hostnames.find_all{|r| r.marked_for_destruction?}.each do |c|
      c.delete
    end
  end

  # Check for duplicates in the nested form records
  def validate_nested_form
    hostnames = self.target_hostnames.find_all{|r| !r.marked_for_destruction?}.collect{|r|r.hostname}

    errors.add(:base, "Duplicate hostname in the list of additional hostnames") unless
      hostnames.size == hostnames.uniq.size
  end    

end
