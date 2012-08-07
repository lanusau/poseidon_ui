require 'test_helper'

class ScriptTargetTest < ActiveSupport::TestCase
  test "Record can be created" do
    script_target = ScriptTarget.new

    script_target.script = script(:dataguard_check)
    script_target.target = target(:target_two)
    script_target.create_sysdate=DateTime.now
    script_target.update_sysdate=DateTime.now

    assert script_target.save, "Can not create record"
  end

  test "Should not create duplicate assignments" do
    script_target = ScriptTarget.new

    script_target.script = script(:dataguard_check)
    script_target.target = target(:target_one)
    script_target.create_sysdate=DateTime.now
    script_target.update_sysdate=DateTime.now

    assert !script_target.save, "Created duplicate assignment"
  end
end
