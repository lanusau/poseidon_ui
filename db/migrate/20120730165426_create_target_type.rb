class CreateTargetType < ActiveRecord::Migration
  def change
    create_table :target_type, :primary_key => :target_type_id do |t|
      t.string :name, :limit => 200, :null => false
      t.string :url_ruby,:url_jdbc , :limit => 1000, :null => false
      t.datetime :create_sysdate, :update_sysdate, :null => false
    end
    add_index :target_type, ["name"], :name => "psd_target_type_u1", :unique => true
  end
end
