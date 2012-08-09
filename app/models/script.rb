class Script < ActiveRecord::Base
  attr_protected :create_sysdate,:update_sysdate

  has_many :script_category_assigns, :dependent => :delete_all
  has_many :script_targets, :dependent => :delete_all
  has_many :script_groups, :dependent => :delete_all
  has_many :query_columns, :order => "column_position", :dependent => :delete_all
  has_many :script_notifications, :dependent => :delete_all
  has_many :script_person_notifications, :dependent => :delete_all

  validates :name,:presence=>true,
            :uniqueness => {:case_sensitive =>false, :message => "- duplicate name"}
  validates :description,:presence=>true
  validates :schedule_min,  :format => { :with =>/[\s\d\-\/,*]+/, :allow_blank=>true,:message => "- invalid format"}
  validates :schedule_hour, :format => { :with =>/[\s\d\-\/,*]+/, :allow_blank=>true,:message => "- invalid format"}
  validates :schedule_day,  :format => { :with =>/[\s\d\-\/,L?*]+/, :allow_blank=>true,:message => "- invalid format"}
  validates :schedule_month,:format => { :with =>/[\s\d\-\/,*]+/, :allow_blank=>true,:message => "- invalid format"}
  validates :schedule_week, :format => { :with =>/[\s\d\-\/,?*]+/, :allow_blank=>true,:message => "- invalid format"}
  validates :query_type, :presence=>true, :numericality => true, :inclusion => {:in => 1..2}
  validates :timeout_sec, :numericality => true
  validates :fixed_severity, :numericality => true, :inclusion => {:in => 0..3}
  validates :severity_column_position, :numericality => true
  validates :value_med_severity, :numericality => true, :allow_nil=>true
  validates :value_high_severity, :numericality => true, :allow_nil=>true
  validates :message_format, :presence=>true,:numericality => true, :inclusion => {:in => 0..1}
  validates :status_code, :presence=>true, :inclusion => {:in =>%w( A I)}
  validates :create_sysdate, :presence=>true
  validates :update_sysdate, :presence=>true

  validate :schedule_day_or_week_must_have_question

  # Either schedule day or week must have question mark
  def schedule_day_or_week_must_have_question
    errors.add(:base, "Either day or week has to contain character ?") if (schedule_day != "?") && (schedule_week != "?")
  end
end
