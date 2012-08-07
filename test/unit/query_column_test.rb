require 'test_helper'

class QueryColumnTest < ActiveSupport::TestCase
  test "Record can be created" do
    query_column = QueryColumn.new(
      :column_position => 3,
      :column_name_str => "max_applied_seq"
    )

    query_column.script = script(:dataguard_check)
    query_column.create_sysdate=DateTime.now
    query_column.update_sysdate=DateTime.now

    assert query_column.save, "Can not create record"
  end
end
