require 'test_helper'

class TargetTypeTest < ActiveSupport::TestCase
  test "Record can be created" do
    target_type = TargetType.new(
      :name => "Postgres",
      :url_ruby => 'dbi:Pg:dbname=%d;host=%h;port=%p',
      :url_jdbc => 'jdbc:postgresql://%h:%p/%d')

    target_type.create_sysdate=DateTime.now
    target_type.update_sysdate=DateTime.now

    assert target_type.save, "Can not create record"
  end
end
