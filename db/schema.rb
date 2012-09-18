# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120917224551) do

  create_table "notify_group", :primary_key => "notify_group_id", :force => true do |t|
    t.string   "name",           :limit => 200, :null => false
    t.datetime "create_sysdate",                :null => false
    t.datetime "update_sysdate",                :null => false
  end

  add_index "notify_group", ["name"], :name => "psd_notify_group_u1", :unique => true

  create_table "notify_group_email", :primary_key => "notify_group_email_id", :force => true do |t|
    t.integer  "notify_group_id",                :null => false
    t.integer  "severity",                       :null => false
    t.string   "email_address",   :limit => 200, :null => false
    t.datetime "create_sysdate",                 :null => false
    t.datetime "update_sysdate",                 :null => false
  end

  add_index "notify_group_email", ["notify_group_id"], :name => "psd_notify_group_email_n1"

  create_table "query_column", :primary_key => "query_column_id", :force => true do |t|
    t.integer  "script_id",                     :null => false
    t.integer  "column_position",               :null => false
    t.string   "column_name_str", :limit => 30, :null => false
    t.datetime "create_sysdate",                :null => false
    t.datetime "update_sysdate",                :null => false
  end

  add_index "query_column", ["script_id"], :name => "psd_query_column_n1"

  create_table "script", :primary_key => "script_id", :force => true do |t|
    t.string   "name",                     :limit => 200,                  :null => false
    t.text     "description",                                              :null => false
    t.string   "schedule_min",             :limit => 100, :default => "",  :null => false
    t.string   "schedule_hour",            :limit => 100, :default => "",  :null => false
    t.string   "schedule_day",             :limit => 100, :default => "",  :null => false
    t.string   "schedule_month",           :limit => 100, :default => "",  :null => false
    t.string   "schedule_week",            :limit => 100, :default => "",  :null => false
    t.integer  "query_type",                              :default => 0,   :null => false
    t.text     "query_text"
    t.integer  "timeout_sec",                             :default => 0,   :null => false
    t.integer  "fixed_severity",                          :default => 0,   :null => false
    t.integer  "severity_column_position"
    t.integer  "value_med_severity"
    t.integer  "value_high_severity"
    t.text     "expression_text"
    t.integer  "message_format",                          :default => 0,   :null => false
    t.string   "message_subject",          :limit => 200
    t.text     "message_header"
    t.text     "message_text_str"
    t.text     "message_footer"
    t.string   "status_code",              :limit => 1,   :default => "I", :null => false
    t.datetime "create_sysdate",                                           :null => false
    t.datetime "update_sysdate",                                           :null => false
  end

  add_index "script", ["name"], :name => "psd_script_u1", :unique => true

  create_table "script_category", :primary_key => "script_category_id", :force => true do |t|
    t.string   "name",           :limit => 200, :null => false
    t.datetime "create_sysdate",                :null => false
    t.datetime "update_sysdate",                :null => false
  end

  add_index "script_category", ["name"], :name => "psd_script_category_u1", :unique => true

  create_table "script_category_assign", :primary_key => "script_category_assign_id", :force => true do |t|
    t.integer  "script_category_id", :null => false
    t.integer  "script_id",          :null => false
    t.datetime "create_sysdate",     :null => false
    t.datetime "update_sysdate",     :null => false
  end

  add_index "script_category_assign", ["script_category_id", "script_id"], :name => "psd_script_category_assign_u1", :unique => true
  add_index "script_category_assign", ["script_id"], :name => "psd_script_category_assign_n1"

  create_table "script_group", :primary_key => "script_group_id", :force => true do |t|
    t.integer  "target_group_id", :null => false
    t.integer  "script_id",       :null => false
    t.datetime "create_sysdate",  :null => false
    t.datetime "update_sysdate",  :null => false
  end

  add_index "script_group", ["script_id"], :name => "psd_script_group_n1"
  add_index "script_group", ["target_group_id", "script_id"], :name => "psd_script_group_u1", :unique => true

  create_table "script_log", :primary_key => "script_log_id", :force => true do |t|
    t.integer  "script_id",           :null => false
    t.datetime "start_date",          :null => false
    t.datetime "finish_date"
    t.integer  "status_number",       :null => false
    t.integer  "error_status_code",   :null => false
    t.integer  "trigger_status_code", :null => false
    t.datetime "create_sysdate",      :null => false
    t.datetime "update_sysdate",      :null => false
  end

  add_index "script_log", ["create_sysdate"], :name => "psd_script_log_n2"
  add_index "script_log", ["script_id"], :name => "psd_script_log_n1"
  add_index "script_log", ["start_date"], :name => "psd_script_log_n4"
  add_index "script_log", ["update_sysdate"], :name => "psd_script_log_n3"

  create_table "script_notification", :primary_key => "script_notification_id", :force => true do |t|
    t.integer  "notify_group_id", :null => false
    t.integer  "script_id",       :null => false
    t.datetime "create_sysdate",  :null => false
    t.datetime "update_sysdate",  :null => false
  end

  add_index "script_notification", ["notify_group_id", "script_id"], :name => "psd_script_notification_u1", :unique => true
  add_index "script_notification", ["script_id"], :name => "psd_script_notification_n1"

  create_table "script_person_notification", :primary_key => "script_person_notification_id", :force => true do |t|
    t.integer  "script_id",      :null => false
    t.string   "email_address",  :null => false
    t.datetime "create_sysdate", :null => false
    t.datetime "update_sysdate", :null => false
  end

  add_index "script_person_notification", ["script_id"], :name => "psd_script_person_notification_n1"

  create_table "script_target", :primary_key => "script_target_id", :force => true do |t|
    t.integer  "target_id",      :null => false
    t.integer  "script_id",      :null => false
    t.datetime "create_sysdate", :null => false
    t.datetime "update_sysdate", :null => false
  end

  add_index "script_target", ["script_id"], :name => "psd_script_target_n1"
  add_index "script_target", ["target_id", "script_id"], :name => "psd_script_target_u1", :unique => true

  create_table "script_target_col_log", :primary_key => "script_target_col_log_id", :force => true do |t|
    t.integer  "script_target_row_log_id", :null => false
    t.integer  "column_number",            :null => false
    t.text     "column_value",             :null => false
    t.datetime "create_sysdate",           :null => false
    t.datetime "update_sysdate",           :null => false
  end

  add_index "script_target_col_log", ["create_sysdate"], :name => "psd_script_target_col_log_n2"
  add_index "script_target_col_log", ["script_target_row_log_id"], :name => "psd_script_target_col_log_n1"

  create_table "script_target_log", :primary_key => "script_target_log_id", :force => true do |t|
    t.integer  "script_log_id",  :null => false
    t.integer  "target_id",      :null => false
    t.datetime "start_date",     :null => false
    t.datetime "finish_date"
    t.integer  "status_number",  :null => false
    t.text     "error_message"
    t.integer  "severity"
    t.datetime "create_sysdate", :null => false
    t.datetime "update_sysdate", :null => false
  end

  add_index "script_target_log", ["create_sysdate"], :name => "psd_script_target_log_n4"
  add_index "script_target_log", ["finish_date"], :name => "psd_script_target_log_n3"
  add_index "script_target_log", ["script_log_id"], :name => "psd_script_target_log_n1"
  add_index "script_target_log", ["target_id"], :name => "psd_script_target_log_n2"

  create_table "script_target_row_log", :primary_key => "script_target_row_log_id", :force => true do |t|
    t.integer  "script_target_log_id",     :null => false
    t.integer  "row_number",               :null => false
    t.integer  "expression_result",        :null => false
    t.text     "expression_error_message"
    t.integer  "severity",                 :null => false
    t.datetime "create_sysdate",           :null => false
    t.datetime "update_sysdate",           :null => false
  end

  add_index "script_target_row_log", ["create_sysdate"], :name => "psd_script_target_row_log_n2"
  add_index "script_target_row_log", ["script_target_log_id"], :name => "psd_script_target_row_log_n1"

  create_table "server", :primary_key => "server_id", :force => true do |t|
    t.string   "name",              :limit => 200, :null => false
    t.string   "location",          :limit => 200
    t.string   "status_code",       :limit => 1,   :null => false
    t.datetime "heartbeat_sysdate"
    t.datetime "create_sysdate",                   :null => false
    t.datetime "update_sysdate",                   :null => false
  end

  add_index "server", ["name"], :name => "psd_server_u1", :unique => true

  create_table "target", :primary_key => "target_id", :force => true do |t|
    t.integer  "target_type_id",                                                  :null => false
    t.integer  "server_id",                                                       :null => false
    t.string   "name",             :limit => 200,                                 :null => false
    t.string   "hostname",         :limit => 100,                                 :null => false
    t.string   "database_name",    :limit => 100,                                 :null => false
    t.integer  "port_number",                                                     :null => false
    t.string   "monitor_username", :limit => 30,                                  :null => false
    t.string   "salt",             :limit => 16,  :default => "0123456789ABCDEF", :null => false
    t.string   "monitor_password", :limit => 30,                                  :null => false
    t.string   "status_code",      :limit => 1,                                   :null => false
    t.datetime "inactive_until"
    t.datetime "create_sysdate",                                                  :null => false
    t.datetime "update_sysdate",                                                  :null => false
  end

  add_index "target", ["name"], :name => "psd_target_u1", :unique => true

  create_table "target_group", :primary_key => "target_group_id", :force => true do |t|
    t.string   "name",           :limit => 200, :null => false
    t.datetime "create_sysdate",                :null => false
    t.datetime "update_sysdate",                :null => false
  end

  add_index "target_group", ["name"], :name => "psd_target_group_u1", :unique => true

  create_table "target_group_assignment", :primary_key => "target_group_assignment_id", :force => true do |t|
    t.integer  "target_id",                    :null => false
    t.integer  "target_group_id",              :null => false
    t.string   "status_code",     :limit => 1, :null => false
    t.datetime "inactive_until"
    t.datetime "create_sysdate",               :null => false
    t.datetime "update_sysdate",               :null => false
  end

  add_index "target_group_assignment", ["target_group_id", "target_id"], :name => "psd_target_group_assignment_u1", :unique => true
  add_index "target_group_assignment", ["target_id"], :name => "psd_target_group_assignment_n1"

  create_table "target_hostname", :primary_key => "target_hostname_id", :force => true do |t|
    t.integer  "target_id",                     :null => false
    t.string   "hostname",       :limit => 100, :null => false
    t.datetime "create_sysdate",                :null => false
    t.datetime "update_sysdate",                :null => false
  end

  add_index "target_hostname", ["target_id", "hostname"], :name => "psd_target_hostname_u1", :unique => true

  create_table "target_type", :primary_key => "target_type_id", :force => true do |t|
    t.string   "name",           :limit => 200,  :null => false
    t.string   "url_ruby",       :limit => 1000, :null => false
    t.string   "url_jdbc",       :limit => 1000, :null => false
    t.datetime "create_sysdate",                 :null => false
    t.datetime "update_sysdate",                 :null => false
  end

  add_index "target_type", ["name"], :name => "psd_target_type_u1", :unique => true

  create_table "user", :primary_key => "user_id", :force => true do |t|
    t.string   "login",           :limit => 200, :null => false
    t.string   "password_digest",                :null => false
    t.integer  "access_level",                   :null => false
    t.datetime "create_sysdate",                 :null => false
    t.datetime "update_sysdate",                 :null => false
  end

  add_index "user", ["login"], :name => "psd_user_u1", :unique => true

end
