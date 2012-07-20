require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "Required fields should be present" do
    user = User.new
    user.create_sysdate = DateTime.now
    user.update_sysdate = DateTime.now

    assert !user.save, "Saved server record without mandatory fields"
  end

  test "Test that record can be created" do
    user = User.new(
      :login=>"test1",
      :password=>"test123",
      :password_confirmation=>"test123",
      :access_level=>1)

    user.create_sysdate=DateTime.now
    user.update_sysdate=DateTime.now

    assert user.save, "Can not create record"
  end
  
  test "Test that password should match" do
    user = User.new(
      :login=>"test2",
      :password=>"test123",
      :password_confirmation=>"no match",
      :access_level=>1)

    user.create_sysdate=DateTime.now
    user.update_sysdate=DateTime.now

    assert !user.save, "Created user without matching password confirmation"
  end

  test "No duplicate logins" do
    user = User.new(
      :login=>"admin",
      :password=>"test123",
      :password_confirmation=>"test123",
      :access_level=>1)

    user.create_sysdate=DateTime.now
    user.update_sysdate=DateTime.now

    assert !user.save, "Saved user with duplicate login"
  end
end
