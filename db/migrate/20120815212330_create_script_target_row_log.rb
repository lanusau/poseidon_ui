class CreateScriptTargetRowLog < ActiveRecord::Migration
  def change
    create_table :script_target_row_log,:primary_key => :script_target_row_log_id do |t|
      t.integer :script_target_log_id, :null => false
      t.integer :row_number,:expression_result, :null => false
      t.text :expression_error_message
      t.integer :severity, :null => false
      t.datetime :create_sysdate, :update_sysdate, :null => false
    end
    add_index :script_target_row_log, ["script_target_log_id"], :name => "psd_script_target_row_log_n1"
    add_index :script_target_row_log, ["create_sysdate"], :name => "psd_script_target_row_log_n2"
  end
end
