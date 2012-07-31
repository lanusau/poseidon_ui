class ScriptCategory < ActiveRecord::Base
  attr_accessible :name

  validates :name,:presence=>true,
            :uniqueness => {:case_sensitive =>false, :message => "- duplicate name"}
end
