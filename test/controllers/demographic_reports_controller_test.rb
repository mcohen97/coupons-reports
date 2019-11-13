require 'test_helper'

class DemographicReportsControllerTest < ActionDispatch::IntegrationTest

  # Organization id: 1, Permissions: GET_DEMOGRAPHIC_REPORT
  APP_KEY1 = 'eyJhbGciOiJIUzI1NiJ9.eyJuYW1lIjoicGVkaWRvc1lhS2V5Iiwib3JnYW5pemF0aW9uX2lkIjoxLCJwZXJtaXNzaW9ucyI6WyJHRVRfREVNT0dSQVBISUNfUkVQT1JUIl19.1lhSou8nyMUpd5z2Z-RWDJRv78XgfVgFBRaP5NXw3Ho'
  
  # Organization id: 1, no permissions
  APP_KEY2 = 'eyJhbGciOiJIUzI1NiJ9.eyJuYW1lIjoicGVkaWRvc1lhS2V5Iiwib3JnYW5pemF0aW9uX2lkIjoxLCJwZXJtaXNzaW9ucyI6W119.PcH4QeiQMmRggz98s9nasVuwd4B30Y2m3WBhV_n0Xgc'

  test 'should generate report correctly ' do
    get demographic_reports_url(1), headers: { Authorization: APP_KEY1 }
    assert_response :success
    report = JSON.parse(response.body)
    puts report.inspect

    countries = report['countries']
    assert_equal 2, countries.length
    assert_equal 1, countries['uruguay']['count']
    assert_equal 1, countries['argentina']['count']

    assert_equal 1, countries['uruguay']['cities']['montevideo']['count']
    assert_equal 1, countries ['argentina']['cities']['buenos aires']['count']

    ages = report['ages'] 
    assert_equal 3, ages.length
    assert_equal 1, ages['18-25']['count']
    assert_equal 1, ages['25-40']['count']
    assert_equal 0, ages['40-60']['count']
  end

  test 'should handle non existing reports' do
    get demographic_reports_url(5), headers: { Authorization: APP_KEY1 }
    assert_response :not_found
    assert JSON.parse(response.body)['error_message']
  end

  test 'should not get report without app key' do
    # Report 2 is from organization 2, appkey is from organization 1
    get demographic_reports_url(2)
    assert_response :unauthorized
    assert response.body['error_message']    
  end

  test "shouldn't not allow access to other organizations promotions" do
    # Report 2 is from organization 2, appkey is from organization 1
    get demographic_reports_url(2), headers: { Authorization: APP_KEY1 }
    assert_response :forbidden
    assert response.body['error_message']
  end

  test "should not allow access to same organization's report without permission" do
    # APPKEY2 has no permission to get usage reports
    get demographic_reports_url(1), headers: { Authorization: APP_KEY2 }
    assert_response :forbidden
    assert response.body['error_message']  
  end

end
