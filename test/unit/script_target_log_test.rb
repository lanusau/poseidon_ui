require 'test_helper'

class ScriptTargetLogTest < ActiveSupport::TestCase
  test "record can be accessed" do
    script_target_log = script_target_log(:dataguard_check_log_one_target_one)
    assert_equal("Not triggered",script_target_log.status_number_str)
    assert_equal("Low",script_target_log.severity_str)
  end
end
