class TargetType < ActiveRecord::Base
  attr_accessible :name, :url_ruby, :url_jdbc

  validates :name,:presence=>true,
            :uniqueness => {:case_sensitive =>false, :message => "- duplicate name"}
  validates :url_ruby, :presence => true
  validates :url_jdbc, :presence => true
end
