require 'test_helper'

class TimeBasicInformationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @time_basic_information = time_basic_informations(:one)
  end

  test "should get index" do
    get time_basic_informations_url
    assert_response :success
  end

  test "should get new" do
    get new_time_basic_information_url
    assert_response :success
  end

  test "should create time_basic_information" do
    assert_difference('TimeBasicInformation.count') do
      post time_basic_informations_url, params: { time_basic_information: { basic_time: @time_basic_information.basic_time, designated_working_times: @time_basic_information.designated_working_times } }
    end

    assert_redirected_to time_basic_information_url(TimeBasicInformation.last)
  end

  test "should show time_basic_information" do
    get time_basic_information_url(@time_basic_information)
    assert_response :success
  end

  test "should get edit" do
    get edit_time_basic_information_url(@time_basic_information)
    assert_response :success
  end

  test "should update time_basic_information" do
    patch time_basic_information_url(@time_basic_information), params: { time_basic_information: { basic_time: @time_basic_information.basic_time, designated_working_times: @time_basic_information.designated_working_times } }
    assert_redirected_to time_basic_information_url(@time_basic_information)
  end

  test "should destroy time_basic_information" do
    assert_difference('TimeBasicInformation.count', -1) do
      delete time_basic_information_url(@time_basic_information)
    end

    assert_redirected_to time_basic_informations_url
  end
end
