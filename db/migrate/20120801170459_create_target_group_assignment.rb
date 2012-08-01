class CreateTargetGroupAssignment < ActiveRecord::Migration
  def change
    create_table :target_group_assignment, :primary_key=>:target_group_assignment_id do |t|
      t.integer :target_id, :target_group_id, :null => false
      t.string :status_code, :limit => 1, :null => false
      t.datetime :inactive_until
      t.datetime :create_sysdate, :update_sysdate, :null => false
    end
    add_index :target_group_assignment, ["target_group_id","target_id"], :name => "psd_target_group_assignment_u1", :unique => true
    add_index :target_group_assignment, ["target_id"], :name => "psd_target_group_assignment_n1"
  end
end
