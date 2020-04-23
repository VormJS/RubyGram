require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @base_title = 'RubyGram'
  end

  test "should get sign up" do
    get signup_path
    assert_response :success
    assert_select 'title', "Sign Up | #{@base_title}"
  end
end
