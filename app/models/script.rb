class Script < ActiveRecord::Base
  attr_protected :create_sysdate,:update_sysdate

  has_many :script_category_assigns, :dependent => :delete_all
  has_many :script_targets, :dependent => :delete_all
  has_many :script_groups, :dependent => :delete_all
  has_many :query_columns, :order => "column_position", :dependent => :delete_all
  has_many :script_notifications, :dependent => :delete_all
  has_many :script_person_notifications, :dependent => :delete_all
  has_many :script_logs, :dependent => :delete_all

  validates :name,:presence=>true,
            :uniqueness => {:case_sensitive =>false, :message => "- duplicate name"}
  validates :description,:presence=>true
  validates :schedule_min,  :format => { :with =>/[\s\d\-\/,*]+/, :on=>:update,:message => "- invalid format"}
  validates :schedule_hour, :format => { :with =>/[\s\d\-\/,*]+/, :on=>:update,:message => "- invalid format"}
  validates :schedule_day,  :format => { :with =>/[\s\d\-\/,L?*]+/, :on=>:update,:message => "- invalid format"}
  validates :schedule_month,:format => { :with =>/[\s\d\-\/,*]+/, :on=>:update,:message => "- invalid format"}
  validates :schedule_week, :format => { :with =>/[\s\d\-\/,?*]+/, :on=>:update,:message => "- invalid format"}
  validates :query_type,    :presence=>true, :numericality => true, :inclusion => {:in => 1..2},:on=>:update
  validates :timeout_sec,   :presence=>true, :numericality => true,:on=>:update
  validates :fixed_severity,:presence=>true, :numericality => true, :inclusion => {:in => 0..3},:on=>:update
  validates :severity_column_position, :numericality => true, :allow_nil=>true
  validates :value_med_severity, :numericality => true, :allow_nil=>true
  validates :value_high_severity, :numericality => true, :allow_nil=>true
  validates :message_format, :presence=>true,:numericality => true, :inclusion => {:in => 0..1},:on=>:update
  validates :status_code, :presence=>true, :inclusion => {:in =>%w( A I)}
  validates :create_sysdate, :presence=>true
  validates :update_sysdate, :presence=>true

  validate :schedule_day_or_week_must_have_question,:on=>:update
  validate :calculated_severity_needs_other_columns,:on=>:update

  # If severity is specified to be calculated based of other columns,
  # those other columns need to be specified
  def calculated_severity_needs_other_columns
    errors.add(:severity_column_position,
      "When specifying severity to be calculated, specify column position") if
     (fixed_severity == 0) && (severity_column_position.blank?)

    errors.add(:value_med_severity,
      "When specifying severity to be calculated, specify medium threshold") if
     (fixed_severity == 0) && (value_med_severity.blank?)

    errors.add(:value_high_severity,
      "When specifying severity to be calculated, specify high threshold") if
     (fixed_severity == 0) && (value_high_severity.blank?)

  end

  # Either schedule day or week must have question mark
  def schedule_day_or_week_must_have_question
    errors.add(:base, "Either day or week has to contain character ?") if (schedule_day != "?") && (schedule_week != "?")
  end

  # Get first assigned target for the particular script
  def get_first_target

    if self.script_targets.empty? && self.script_groups.empty?
      return nil
    else
      if !self.script_targets.empty?
        target = self.script_targets[0].target
      else
        if self.script_groups[0].target_group.target_group_assignments.empty?
          return nil
        else
          target = self.script_groups[0].target_group.target_group_assignments[0].target
        end
      end
    end

    return target

  end

  # Clone this script to new object
  def clone_script
    new_script = self.dup

    # Clone category assignments
    self.script_category_assigns.each do | r |
      new_script.script_category_assigns.build(:script_category_id => r.script_category_id)
    end

    # Clone script targets
    self.script_targets.each do | r |
      new_script.script_targets.build(:target_id => r.target_id)
    end

    # Clone script groups
    self.script_groups.each do | r |
      new_script.script_groups.build(:target_group_id => r.target_group_id)
    end

    # Clone script query columns
    self.query_columns.each do | r |
      new_script.query_columns.build(
        {
          :column_position => r.column_position,
          :column_name_str => r.column_name_str
        })
    end

    # Clone script notifications
    self.script_notifications.each do | r |
      new_script.script_notifications.build(:notify_group_id => r.notify_group_id)
    end

    # Clone script personal notifications
    self.script_person_notifications.each do | r |
      new_script.script_person_notifications.build(:email_address => r.email_address)
    end

    return new_script

  end
end
