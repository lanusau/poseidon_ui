class CreateScriptCategoryAssign < ActiveRecord::Migration
  def change
    create_table :script_category_assign, :primary_key => :script_category_assign_id do |t|
      t.integer :script_category_id,:null => false
      t.integer :script_id,:null => false
      t.datetime :create_sysdate, :update_sysdate, :null => false
    end
    add_index :script_category_assign, ["script_category_id","script_id"], :name => "psd_script_category_assign_u1", :unique => true
    add_index :script_category_assign, ["script_id"], :name => "psd_script_category_assign_n1"
  end
end
