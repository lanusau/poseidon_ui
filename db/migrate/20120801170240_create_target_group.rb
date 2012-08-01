class CreateTargetGroup < ActiveRecord::Migration
  def change
    create_table :target_group,:primary_key => :target_group_id do |t|
      t.string :name, :limit => 200, :null => false
      t.datetime :create_sysdate, :update_sysdate, :null => false
    end
    add_index :target_group, ["name"], :name => "psd_target_group_u1", :unique => true
  end
end
