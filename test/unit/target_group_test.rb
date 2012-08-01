require 'test_helper'

class TargetGroupTest < ActiveSupport::TestCase
  test "Record can be created" do
    target_group = TargetGroup.new(
      :name => "Billing")

    target_group.create_sysdate=DateTime.now
    target_group.update_sysdate=DateTime.now

    assert target_group.save, "Can not create record"
  end
end
