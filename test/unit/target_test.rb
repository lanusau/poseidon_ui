require 'test_helper'

class TargetTest < ActiveSupport::TestCase

  test "Required fields should be present" do
    target = Target.new
    target.hostname = "Some location"

    assert !target.save, "Saved target record without mandatory fields"
  end

  test "status_code values should only be A and I" do
    target = target(:target_one)
    target.status_code = "B"
    assert !target.save, "Saved with invalid status code"
  end

  test "Record can be created" do
    target = Target.new(
      :name => "Production Billing Database",
      :hostname => "test1.com",
      :database_name => "billing",
      :port_number => 1521,
      :monitor_username => "monitor",
      :monitor_password => "monitor",
      :status_code => 'A')

    target_type = target_type(:oracle)
    server = server(:production)
    target.target_type = target_type
    target.server = server

    target.create_sysdate=DateTime.now
    target.update_sysdate=DateTime.now

    assert target.save, "Can not create target record"
  end

  test "No uplicate names" do
    target = Target.new(
      :name => "oracle@target1.com",
      :hostname => "test1.com",
      :database_name => "billing",
      :port_number => 1521,
      :monitor_username => "monitor",
      :monitor_password => "monitor",
      :status_code => 'A')

    target_type = target_type(:oracle)
    server = server(:production)
    target.target_type = target_type
    target.server = server

    target.create_sysdate=DateTime.now
    target.update_sysdate=DateTime.now

    assert !target.save, "Saved target with duplicate name"
  end

  test "No invalid port numbers" do
    target = target(:target_one)
    target.port_number = 'ABC'
    assert !target.save, "Saved target with invalid port number"
  end

  test "Date validation" do
    # Valid date set as string
    target = target(:target_one)
    target.inactive_until = '08-29-2012 00:00:01'
    assert target.valid?, 'Valid date passed as string did not validate'
    assert_not_nil target.inactive_until, "Valid date got set as nil"

    # Valid date set as DateTime
    target.inactive_until = DateTime.now()
    assert target.valid?, 'Valid date passed as DateTime did not validate'

    # Null should be valid
    target.inactive_until = nil
    assert target.valid?, 'Nil date did not validate'

    # Finally - invalid date
    target.inactive_until = 'RFD1111'
    assert !target.valid?, 'Invalid date validated'
  end

end
