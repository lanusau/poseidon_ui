require 'test_helper'

class NotifyGroupTest < ActiveSupport::TestCase
  test "Record can be created" do
    notify_group= NotifyGroup.new(
      :name => "Oracle")

    notify_group.create_sysdate=DateTime.now
    notify_group.update_sysdate=DateTime.now

    assert notify_group.save, "Can not create record"
  end

  test "Deleting record should remove child records" do
    notify_group = NotifyGroup.find_by_name("dba")
    assert_difference("NotifyGroupEmail.count",-3) do
      notify_group.destroy
    end
  end
end
