class CreateScriptCategory < ActiveRecord::Migration
  def change
    create_table :script_category, :primary_key => :script_category_id do |t|
      t.string :name, :limit => 200, :null => false
      t.datetime :create_sysdate, :update_sysdate, :null => false
    end
    add_index :script_category, ["name"], :name => "psd_script_category_u1", :unique => true
  end
end
