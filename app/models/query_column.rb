class QueryColumn < ActiveRecord::Base
  attr_accessible :column_position,:column_name_str
  belongs_to :script
end
