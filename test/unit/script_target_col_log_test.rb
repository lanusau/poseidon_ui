require 'test_helper'

class ScriptTargetColLogTest < ActiveSupport::TestCase
  test "record can be accessed" do
    script_target_col_log = script_target_col_log(:one)
    assert_equal("10",script_target_col_log.column_value)
  end
end
