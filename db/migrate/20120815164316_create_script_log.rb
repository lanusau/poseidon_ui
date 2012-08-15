class CreateScriptLog < ActiveRecord::Migration
  def change
    create_table :script_log,:primary_key => :script_log_id do |t|
      t.integer :script_id,:null => false
      t.datetime :start_date, :null => false
      t.datetime :finish_date
      t.integer :status_number,:error_status_code,:trigger_status_code,:null => false
      t.datetime :create_sysdate, :update_sysdate, :null => false
    end
    add_index :script_log, ["script_id"], :name => "psd_script_log_n1"
    add_index :script_log, ["create_sysdate"], :name => "psd_script_log_n2"
    add_index :script_log, ["update_sysdate"], :name => "psd_script_log_n3"
    add_index :script_log, ["start_date"], :name => "psd_script_log_n4"
  end
end
