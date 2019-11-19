require 'test_helper'

class UsageReportsControllerTest < ActionDispatch::IntegrationTest
  
  # Organization id: 1, Permissions: GET_USAGE_REPORT
  APP_KEY1 = 'eyJhbGciOiJIUzI1NiJ9.eyJuYW1lIjoicGVkaWRvc1lhS2V5Iiwib3JnYW5pemF0aW9uX2lkIjoxLCJwZXJtaXNzaW9ucyI6WyJHRVRfVVNBR0VfUkVQT1JUIl19.4cUHRybAGTgAYUELwcs600rj-wtZ0OAtFZCDMDlhjz4'
  
  # Organization id: 1, Permissions: GET_DEMOGRAPHIC_REPORT
  APP_KEY2 = 'eyJhbGciOiJIUzI1NiJ9.eyJuYW1lIjoicGVkaWRvc1lhS2V5Iiwib3JnYW5pemF0aW9uX2lkIjoxLCJwZXJtaXNzaW9ucyI6WyJHRVRfREVNT0dSQVBISUNfUkVQT1JUIl19.1lhSou8nyMUpd5z2Z-RWDJRv78XgfVgFBRaP5NXw3Ho'

  test 'should handle non existing reports' do
    get api_v1_usage_reports_url(5), headers: { Authorization: APP_KEY1 }
    assert_response :not_found
    assert JSON.parse(response.body)['error_message']
  end

  test 'should generate report correctly ' do
    get api_v1_usage_reports_url(1), headers: { Authorization: APP_KEY1 }
    assert_response :success
    report = JSON.parse(response.body)
    assert_equal 2, report['invocations_count']
    assert_equal 0.5, report['positive_response_ratio']
    assert_equal 0.5, report['negative_response_ratio']
    assert_equal 150, report['total_money_spent']
    assert_equal 0.5, report['average_response_time']
    assert_equal Date.new(2018, 11, 29), Date.parse(report['last_time_updated'])
  end

  test 'should not get report without app key' do
    # Report 2 is from organization 2, appkey is from organization 1
    get api_v1_usage_reports_url(2)
    assert_response :unauthorized
    assert JSON.parse(response.body)['error_message']
  end

  test "shouldn't not allow access to other organizations promotions" do
    # Report 2 is from organization 2, appkey is from organization 1
    get api_v1_usage_reports_url(2), headers: { Authorization: APP_KEY1 }
    assert_response :forbidden
    assert JSON.parse(response.body)['error_message']
  end

  test "should not allow access to same organization's report without permission" do
    # APPKEY2 has no permission to get usage reports
    get api_v1_usage_reports_url(1), headers: { Authorization: APP_KEY2 }
    assert_response :forbidden
    assert JSON.parse(response.body)['error_message']
  end

end
