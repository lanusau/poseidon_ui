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

ActiveRecord::Schema.define(:version => 20120801170510) do

  create_table "notify_group", :primary_key => "notify_group_id", :force => true do |t|
    t.string   "name",           :limit => 200, :null => false
    t.datetime "create_sysdate",                :null => false
    t.datetime "update_sysdate",                :null => false
  end

  add_index "notify_group", ["name"], :name => "psd_notify_group_u1", :unique => true

  create_table "notify_group_email", :primary_key => "notify_group_email_id", :force => true do |t|
    t.integer  "notify_group_id",                :null => false
    t.integer  "severity",                       :null => false
    t.string   "email",           :limit => 200, :null => false
    t.datetime "create_sysdate",                 :null => false
    t.datetime "update_sysdate",                 :null => false
  end

  add_index "notify_group_email", ["notify_group_id"], :name => "psd_notify_group_email_n1"

  create_table "script_category", :primary_key => "script_category_id", :force => true do |t|
    t.string   "name",           :limit => 200, :null => false
    t.datetime "create_sysdate",                :null => false
    t.datetime "update_sysdate",                :null => false
  end

  add_index "script_category", ["name"], :name => "psd_script_category_u1", :unique => true

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
    t.integer  "target_type_id",                  :null => false
    t.integer  "server_id",                       :null => false
    t.string   "name",             :limit => 200, :null => false
    t.string   "hostname",         :limit => 100, :null => false
    t.string   "database_name",    :limit => 100, :null => false
    t.integer  "port_number",                     :null => false
    t.string   "monitor_username", :limit => 30,  :null => false
    t.string   "monitor_password", :limit => 30,  :null => false
    t.string   "status_code",      :limit => 1,   :null => false
    t.datetime "inactive_until"
    t.datetime "create_sysdate",                  :null => false
    t.datetime "update_sysdate",                  :null => false
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
