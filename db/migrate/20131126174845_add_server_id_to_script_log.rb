class AddServerIdToScriptLog < ActiveRecord::Migration
  def change
    add_column :script_log, :server_id, :integer, :after => :script_id, :null=> false, :default => 1
  end
end
