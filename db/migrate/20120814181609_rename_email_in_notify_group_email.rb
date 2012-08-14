class RenameEmailInNotifyGroupEmail < ActiveRecord::Migration
  def up
    rename_column(:notify_group_email, :email, :email_address)
  end

  def down
    rename_column(:notify_group_email, :email_address, :email)
  end
end
