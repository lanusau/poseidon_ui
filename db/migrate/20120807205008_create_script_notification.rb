class CreateScriptNotification < ActiveRecord::Migration
  def change
    create_table :script_notification,:primary_key => :script_notification_id  do |t|
      t.integer :notify_group_id,:null => false
      t.integer :script_id,:null => false
      t.datetime :create_sysdate, :update_sysdate, :null => false
    end
    add_index :script_notification, ["notify_group_id","script_id"], :name => "psd_script_notification_u1", :unique => true
    add_index :script_notification, ["script_id"], :name => "psd_script_notification_n1"
  end
end
