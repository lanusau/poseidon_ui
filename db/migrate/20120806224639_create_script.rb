class CreateScript < ActiveRecord::Migration
  def change
    create_table :script, :primary_key => :script_id do |t|
      t.string :name, :limit => 200, :null => false
      t.text :description, :null => false
      t.string :schedule_min,  :limit => 100, :null => false, :default =>  ''
      t.string :schedule_hour, :limit => 100, :null => false, :default =>  ''
      t.string :schedule_day,  :limit => 100, :null => false, :default =>  ''
      t.string :schedule_month,:limit => 100, :null => false, :default =>  ''
      t.string :schedule_week, :limit => 100, :null => false, :default =>  ''
      t.integer :query_type, :null => false, :default =>  0
      t.text :query_text
      t.integer :timeout_sec, :null => false, :default => 0
      t.integer :fixed_severity, :null => false, :default =>  0
      t.integer :severity_column_position
      t.integer :value_med_severity
      t.integer :value_high_severity
      t.text :expression_text
      t.integer :message_format, :null => false, :default =>  0
      t.string :message_subject ,:limit => 200
      t.text :message_header
      t.text :message_text_str
      t.text :message_footer
      t.string :status_code, :limit => 1,:null => false, :default =>  'I'
      t.datetime :create_sysdate, :update_sysdate, :null => false
    end

    add_index :script, ["name"], :name => "psd_script_u1", :unique => true
  end
end
