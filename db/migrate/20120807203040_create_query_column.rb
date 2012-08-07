class CreateQueryColumn < ActiveRecord::Migration
  def change
    create_table :query_column,:primary_key => :query_column_id  do |t|
      t.integer :script_id,:null => false
      t.integer :column_position, :null => false
      t.string :column_name_str, :null => false ,:limit => 30
      t.datetime :create_sysdate, :update_sysdate, :null => false
    end
    add_index :query_column, ["script_id"], :name => "psd_query_column_n1"
  end
end
