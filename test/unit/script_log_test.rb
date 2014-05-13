require 'test_helper'

class ScriptLogTest < ActiveSupport::TestCase
  test "record can be accessed" do
    script_log = script_log(:dataguard_check_log_one)
    assert_equal("Finished",script_log.status_number_str)
    assert script_log.error_status_code_str.blank?
    assert_equal("Triggered",script_log.trigger_status_code_str)
  end
end
