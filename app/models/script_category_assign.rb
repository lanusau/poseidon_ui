class ScriptCategoryAssign < ActiveRecord::Base
  belongs_to :script
  belongs_to :script_category

  validates :script_category_id,:presence=>true,
            :uniqueness => {
              :scope=>"script_id",
              :message => "- already assigned for this script"}
  validates :script_id, :presence=>true  
end
