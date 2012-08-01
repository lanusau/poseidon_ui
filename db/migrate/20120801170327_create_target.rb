class CreateTarget < ActiveRecord::Migration
  def change
    create_table :target,:primary_key => :target_id do |t|
      t.integer :target_type_id,:server_id, :null => false
      t.string :name, :limit => 200, :null => false
      t.string :hostname,:database_name, :limit => 100, :null => false
      t.integer :port_number,:null => false
      t.string :monitor_username, :monitor_password, :limit => 30, :null => false
      t.string :status_code, :limit => 1, :null => false
      t.datetime :inactive_until
      t.datetime :create_sysdate, :update_sysdate, :null => false
    end
    add_index :target, ["name"], :name => "psd_target_u1", :unique => true
  end
end
