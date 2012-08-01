class CreateNotifyGroupEmail < ActiveRecord::Migration
  def change
    create_table :notify_group_email,:primary_key => :notify_group_email_id do |t|
      t.integer :notify_group_id, :null => false
      t.integer :severity, :null => false
      t.string :email, :limit => 200, :null => false
      t.datetime :create_sysdate, :update_sysdate, :null => false
    end
    add_index :notify_group_email, ["notify_group_id"], :name => "psd_notify_group_email_n1"
  end
end
