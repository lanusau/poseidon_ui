class QueryColumn < ActiveRecord::Base
  attr_accessible :column_position,:column_name_str
  belongs_to :script

  before_save :set_update_sysdate
  before_create :set_create_sysdate

  private

  # Set create and update dates automatically
  def set_update_sysdate
    self.update_sysdate = DateTime.now()
  end
  def set_create_sysdate
    self.create_sysdate = DateTime.now()
  end
end
