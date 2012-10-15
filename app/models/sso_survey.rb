class SsoSurvey < ActiveRecord::Base
  self.primary_key = 'survey_id'
  self.table_name = 'sso_survey'
end
