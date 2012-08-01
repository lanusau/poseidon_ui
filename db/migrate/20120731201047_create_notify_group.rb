class CreateNotifyGroup < ActiveRecord::Migration
  def change
    create_table :notify_group, :primary_key => :notify_group_id do |t|
      t.string :name, :limit => 200, :null => false
      t.datetime :create_sysdate, :update_sysdate, :null => false
    end
    add_index :notify_group, ["name"], :name => "psd_notify_group_u1", :unique => true
  end
end
