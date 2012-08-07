require 'test_helper'

class ScriptCategoryAssignTest < ActiveSupport::TestCase

  test "Record can be created" do
    script_category_assign = ScriptCategoryAssign.new

    script_category_assign.script = script(:dataguard_check)
    script_category_assign.script_category = script_category(:billing)
    script_category_assign.create_sysdate=DateTime.now
    script_category_assign.update_sysdate=DateTime.now

    assert script_category_assign.save, "Can not create record"
  end

  test "Should not create duplicate assignments" do
    script_category_assign = ScriptCategoryAssign.new

    script_category_assign.script = script(:dataguard_check)
    script_category_assign.script_category = script_category(:dba_related)
    script_category_assign.create_sysdate=DateTime.now
    script_category_assign.update_sysdate=DateTime.now

    assert !script_category_assign.save, "Created duplicate assignment"
  end
end
