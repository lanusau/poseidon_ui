class CreateScriptPersonNotification < ActiveRecord::Migration
  def change
    create_table :script_person_notification,:primary_key => :script_person_notification_id do |t|
      t.integer :script_id,:null => false
      t.string :email_address,:null => false, :limit => 255      
      t.datetime :create_sysdate, :update_sysdate, :null => false
    end
    add_index :script_person_notification, ["script_id"], :name => "psd_script_person_notification_n1"
  end
end
