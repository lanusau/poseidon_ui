class AddSaltToTarget < ActiveRecord::Migration
  def change
    add_column :target, :salt, :string, :limit=> 16,:after => :monitor_username, :null=> false, :default => '0123456789ABCDEF'
  end
end
