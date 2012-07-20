class CreateServer < ActiveRecord::Migration
  def change
    create_table :server , :primary_key => :server_id do |t|
      t.string :name, :limit => 200, :null => false
      t.string :location, :limit => 200
      t.string :status_code, :limit => 1, :null => false
      t.datetime :heartbeat_sysdate
      t.datetime :create_sysdate, :update_sysdate, :null => false
    end
    add_index :server, ["name"], :name => "psd_server_u1", :unique => true
  end
end
