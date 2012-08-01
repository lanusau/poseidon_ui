require 'test_helper'

class TargetGroupAssignmentTest < ActiveSupport::TestCase
  test "Record can be created" do
    target = target(:target_two)
    target_group = target_group(:production_mysql)
    target_group_assgnment = TargetGroupAssignment.new(
      :status_code => 'A')
    target_group_assgnment.target = target
    target_group_assgnment.target_group = target_group

    target_group_assgnment.create_sysdate=DateTime.now
    target_group_assgnment.update_sysdate=DateTime.now

    assert target_group_assgnment.save, "Can not create record"
  end
end
