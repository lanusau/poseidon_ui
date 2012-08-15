require 'test_helper'

class ScriptTargetRowLogTest < ActiveSupport::TestCase
  test "record can be accessed" do
    script_target_row_log = script_target_row_log(:row_one)
    assert_equal("False",script_target_row_log.expression_result_str)
    assert_equal("Low",script_target_row_log.severity_str)
  end
end
