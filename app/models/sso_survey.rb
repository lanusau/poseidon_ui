class SsoSurvey < ActiveRecord::Base
  self.primary_key = 'survey_id'
  self.table_name = 'sso_survey'

  has_many :sso_survey_supervisors, :foreign_key => "survey_id", :dependent => :delete_all

end
