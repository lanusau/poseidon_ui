class SsoSurveySupervisor < ActiveRecord::Base
  self.primary_key = 'survey_supervisor_id'
  self.table_name = 'sso_survey_supervisor'

  has_many :sso_survey_supervisor_approvals, :foreign_key => "survey_supervisor_id", :dependent => :delete_all
  
end
