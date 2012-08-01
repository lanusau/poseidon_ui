class CreateTargetHostname < ActiveRecord::Migration
  def change
    create_table :target_hostname,:primary_key=>:target_hostname_id do |t|
      t.integer :target_id, :null => false
      t.string :hostname, :limit => 100, :null => false
      t.datetime :create_sysdate, :update_sysdate, :null => false
    end
    add_index :target_hostname, ["target_id","hostname"], :name => "psd_target_hostname_u1", :unique => true
  end
end
