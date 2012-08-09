require 'test_helper'

class ScriptNotificationTest < ActiveSupport::TestCase
  test "Record can be created" do
    script_notification = ScriptNotification.new

    script_notification.script = script(:dataguard_check)
    script_notification.notify_group = notify_group(:ops_db)
    script_notification.create_sysdate=DateTime.now
    script_notification.update_sysdate=DateTime.now

    assert script_notification.save, "Can not create record"
  end

  test "Should not create duplicate assignments" do
    script_notification = ScriptNotification.new

    script_notification.script = script(:dataguard_check)
    script_notification.notify_group = notify_group(:dba)
    script_notification.create_sysdate=DateTime.now
    script_notification.update_sysdate=DateTime.now

    assert !script_notification.save, "Created duplicate assignment"
  end
end
