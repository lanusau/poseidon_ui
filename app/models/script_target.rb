class ScriptTarget < ActiveRecord::Base
  belongs_to :script
  belongs_to :target

  validates :target_id,:presence=>true,
            :uniqueness => {
              :scope=>"script_id",
              :message => "- already assigned for this script"}
  validates :script_id, :presence=>true
end
