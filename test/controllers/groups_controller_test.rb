require "test_helper"

class GroupsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get new_group_url
    assert_response :success
  end

  test "should create group" do
    assert_difference("Group.count") do
      post groups_url, params: { group: { name: "Test Group", password: "password123", password_confirmation: "password123" } }
    end
    assert_redirected_to group_url(Group.last)
  end
end
