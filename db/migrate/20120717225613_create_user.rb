class CreateUser < ActiveRecord::Migration
  def change
    create_table :user, :primary_key => :user_id  do |t|
      t.string :login, :limit=>200, :null => false
      t.string :password_digest , :null => false
      t.integer :access_level, :null => false
      t.datetime :create_sysdate, :update_sysdate, :null => false
    end
    add_index :user, ["login"], :name => "psd_user_u1", :unique => true
  end  
end
