require 'test_helper'

class ScriptTest < ActiveSupport::TestCase

  test "Required fields should be present" do
    script = Script.new
    script.name = "Some script"

    assert !script.save, "Saved record without mandatory fields"
  end

  test "Record can be created" do
    script = Script.new(
      :name => "Test",
      :description => "Test script",
      :schedule_min => "15",
      :schedule_hour => "2,3,4,5",
      :schedule_week => "?",
      :query_type => 1,
      :query_text => "select count(*) from dual",
      :timeout_sec => 300,
      :fixed_severity => 0,
      :severity_column_position => 0,
      :value_med_severity => 1,
      :value_high_severity =>2,
      :expression_text => "%0 > 1",
      :message_format => 0,
      :message_subject => "Test script",
      :message_text_str => "Some alert",
      :status_code => 'A')

    script.create_sysdate=DateTime.now
    script.update_sysdate=DateTime.now

    assert script.save, "Can not create record"
  end

  test "No uplicate names" do    
    script = script(:dataguard_check)
    new_script = script.dup
    assert !new_script.save, "Saved record with duplicate name"
  end

  test "Schedule format should be correct" do
    script = script(:dataguard_check)
    script.schedule_min = "A"
    assert !script.save, "Saved record with invalid schedule format"
    script.schedule_min = "15"
    script.schedule_hour = "A"
    assert !script.save, "Saved record with invalid schedule format"
    script.schedule_hour = "*"
    script.schedule_day = "A"
    assert !script.save, "Saved record with invalid schedule format"
    script.schedule_day = "*"
    script.schedule_month = "A"
    assert !script.save, "Saved record with invalid schedule format"
    script.schedule_month = "*"
    script.schedule_day = "?"
    script.schedule_week = "A"
    assert !script.save, "Saved record with invalid schedule format"
    script.schedule_day = "1"
    script.schedule_week = "1"
    # One of day or week has to always have ? mark
    assert !script.save, "Saved record with invalid schedule format"
  end

  test "Query type value should be correct" do
    script = script(:dataguard_check)
    script.query_type = 5
    assert !script.save, "Saved record with invalid query type"
  end

  test "fixed_severity  value should be correct" do
    script = script(:dataguard_check)
    script.fixed_severity = 5
    assert !script.save, "Saved record with invalid fixed_severity"
  end

  test "message_format  value should be correct" do
    script = script(:dataguard_check)
    script.message_format = 5
    assert !script.save, "Saved record with invalid message_format"
  end

  test "status_code  value should be correct" do
    script = script(:dataguard_check)
    script.status_code = 'B'
    assert !script.save, "Saved record with invalid status_code"
  end

  test "should be able to clone the script" do
    script = script(:dataguard_check)
    new_script = script.clone_script
    new_script.name = 'Dataguard check clone'
    assert new_script.save, 'Could not save cloned script'

    new_script.reload

    # Check that associations were cloned
    assert_equal script.script_category_assigns.size, new_script.script_category_assigns.size
    assert_equal script.script_targets.size, new_script.script_targets.size
    assert_equal script.script_groups.size, new_script.script_groups.size
    assert_equal script.query_columns.size, new_script.query_columns.size
    assert_equal script.script_notifications.size, new_script.script_notifications.size
    assert_equal script.script_person_notifications.size, new_script.script_person_notifications.size
  end

end
