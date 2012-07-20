require 'test_helper'

class ServerTest < ActiveSupport::TestCase

  test "Required fields should be present" do
    server = Server.new
    server.location = "Some location"

    assert !server.save, "Saved server record without mandatory fields"
  end

  test "status_code values should only be A and I" do
    server = server(:one)
    server.status_code = "B"
    assert !server.save, "Saved with invalid status code"
  end

  test "Record can be created" do
    server = Server.new(
      :name => "Staging server",
      :location => "seomwhere in staging",
      :status_code => 'A')

    server.create_sysdate=DateTime.now
    server.update_sysdate=DateTime.now

    assert server.save, "Can not create server record"
  end

  test "No uplicate names" do
    server = Server.new(
      :name => "Production Server",
      :location => "No matter",
      :status_code => 'A')

    server.create_sysdate=DateTime.now
    server.update_sysdate=DateTime.now

    assert !server.save, "Saved server with duplicate name"
  end

end
