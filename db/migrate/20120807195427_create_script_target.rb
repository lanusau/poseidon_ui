class CreateScriptTarget < ActiveRecord::Migration
  def change
    create_table :script_target,:primary_key => :script_target_id  do |t|
      t.integer :target_id,:null => false
      t.integer :script_id,:null => false
      t.datetime :create_sysdate, :update_sysdate, :null => false
    end
    add_index :script_target, ["target_id","script_id"], :name => "psd_script_target_u1", :unique => true
    add_index :script_target, ["script_id"], :name => "psd_script_target_n1"
  end
end
