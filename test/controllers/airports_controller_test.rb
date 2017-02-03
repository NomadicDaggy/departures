require 'test_helper'

class AirportsControllerTest < ActionDispatch::IntegrationTest
  test "should get map" do
    get airports_map_url
    assert_response :success
  end

  test "should get index" do
    get airports_index_url
    assert_response :success
  end

end
