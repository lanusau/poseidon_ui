require 'test_helper'

class ScriptGroupTest < ActiveSupport::TestCase
  test "Record can be created" do
    script_group = ScriptGroup.new

    script_group.script = script(:dataguard_check)
    script_group.target_group = target_group(:production_mysql)
    script_group.create_sysdate=DateTime.now
    script_group.update_sysdate=DateTime.now

    assert script_group.save, "Can not create record"
  end

  test "Should not create duplicate assignments" do
    script_group = ScriptGroup.new

    script_group.script = script(:dataguard_check)
    script_group.target_group = target_group(:production_oracle)
    script_group.create_sysdate=DateTime.now
    script_group.update_sysdate=DateTime.now

    assert !script_group.save, "Created duplicate assignment"
  end
end
