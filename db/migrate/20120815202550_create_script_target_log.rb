class CreateScriptTargetLog < ActiveRecord::Migration
  def change
    create_table :script_target_log,:primary_key => :script_target_log_id do |t|
      t.integer :script_log_id,:target_id, :null => false
      t.datetime :start_date, :null => false
      t.datetime :finish_date
      t.integer :status_number, :null => false
      t.text :error_message
      t.integer :severity
      t.datetime :create_sysdate, :update_sysdate, :null => false
    end
    add_index :script_target_log, ["script_log_id"], :name => "psd_script_target_log_n1"
    add_index :script_target_log, ["target_id"], :name => "psd_script_target_log_n2"
    add_index :script_target_log, ["finish_date"], :name => "psd_script_target_log_n3"
    add_index :script_target_log, ["create_sysdate"], :name => "psd_script_target_log_n4"
  end
end
