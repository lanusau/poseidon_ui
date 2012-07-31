require 'test_helper'

class ScriptCategoryTest < ActiveSupport::TestCase
  test "Record can be created" do
    script_category = ScriptCategory.new(
      :name => "Oracle")

    script_category.create_sysdate=DateTime.now
    script_category.update_sysdate=DateTime.now

    assert script_category.save, "Can not create record"
  end
end
