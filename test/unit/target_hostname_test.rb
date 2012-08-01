require 'test_helper'

class TargetHostnameTest < ActiveSupport::TestCase
  test "Record can be created" do
    target = target(:target_one)
    target_hostname = TargetHostname.new(
      :hostname => "test3.com")

    target_hostname.target = target
    target_hostname.create_sysdate=DateTime.now
    target_hostname.update_sysdate=DateTime.now

    assert target_hostname.save, "Can not create record"
  end
end
