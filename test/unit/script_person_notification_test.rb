require 'test_helper'

class ScriptPersonNotificationTest < ActiveSupport::TestCase
  test "Record can be created" do
    script_person_notification = ScriptPersonNotification.new(
      :email_address => "ceo@company.com"
    )

    script_person_notification.script = script(:dataguard_check)
    script_person_notification.create_sysdate=DateTime.now
    script_person_notification.update_sysdate=DateTime.now

    assert script_person_notification.save, "Can not create record"
  end
end
