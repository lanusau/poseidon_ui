require 'test_helper'

class NotifyGroupEmailTest < ActiveSupport::TestCase
  test "Record can be created" do
    notify_group = NotifyGroup.find_by_name("dba")
    notify_group_email = NotifyGroupEmail.new(
      :severity => 3,
      :email => "something@test.com")

    notify_group_email.notify_group = notify_group
    notify_group_email.create_sysdate=DateTime.now
    notify_group_email.update_sysdate=DateTime.now

    assert notify_group_email.save, "Can not create record"
  end

  test "Record with invalid severity should not be saved" do
    notify_group = NotifyGroup.find_by_name("dba")
    notify_group_email = NotifyGroupEmail.new(
      :severity => 4,
      :email => "something@test.com")

    notify_group_email.notify_group = notify_group
    notify_group_email.create_sysdate=DateTime.now
    notify_group_email.update_sysdate=DateTime.now

    assert !notify_group_email.save, "Saved invalid record"
  end
end
