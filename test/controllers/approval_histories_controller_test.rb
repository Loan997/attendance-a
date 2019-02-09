require 'test_helper'

class ApprovalHistoriesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get approval_histories_index_url
    assert_response :success
  end

end
