class TargetType < ActiveRecord::Base
  attr_accessible :name, :url_ruby, :url_jdbc

  has_many :targets, :dependent => :restrict

  validates :name,:presence=>true,
            :uniqueness => {:case_sensitive =>false, :message => "- duplicate name"}
  validates :url_ruby, :presence => true
  validates :url_jdbc, :presence => true
  validates :create_sysdate, :presence=>true
  validates :update_sysdate, :presence=>true
end
