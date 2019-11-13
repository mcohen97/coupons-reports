require 'test_helper'

class UsageReportsControllerTest < ActionDispatch::IntegrationTest
  
  APP_KEY1 = 'eyJhbGciOiJIUzI1NiJ9.eyJuYW1lIjoicGVkaWRvc1lhS2V5Iiwib3JnYW5pemF0aW9uX2lkIjoxLCJwZXJtaXNzaW9ucyI6WyJHRVRfVVNBR0VfUkVQT1JUIl19.4cUHRybAGTgAYUELwcs600rj-wtZ0OAtFZCDMDlhjz4'

  test 'should generate report correctly ' do
    get usage_reports_url(1), headers: { Authorization: APP_KEY1 }
    assert_response :success
    report = JSON.parse(response.body)
    puts report.inspect
    assert_equal 2, report['invocations_count']
    assert_equal 0.5, report['positive_response_ratio']
    assert_equal 0.5, report['negative_response_ratio']
    assert_equal 150, report['total_money_spent']
    assert_equal 0.5, report['average_response_time']
  end

end
