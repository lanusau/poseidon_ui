class CreateScriptGroup < ActiveRecord::Migration
  def change
    create_table :script_group,:primary_key => :script_group_id do |t|
      t.integer :target_group_id,:null => false
      t.integer :script_id,:null => false
      t.datetime :create_sysdate, :update_sysdate, :null => false
    end
    add_index :script_group, ["target_group_id","script_id"], :name => "psd_script_group_u1", :unique => true
    add_index :script_group, ["script_id"], :name => "psd_script_group_n1"
  end
end
