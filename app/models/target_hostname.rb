class TargetHostname < ActiveRecord::Base
  attr_accessible :hostname

  belongs_to :target

  validates :hostname,:presence=>true,
            :uniqueness => {
              :scope=>"target_id",
              :case_sensitive =>false,
              :message => "- already exists for this target"}
end
