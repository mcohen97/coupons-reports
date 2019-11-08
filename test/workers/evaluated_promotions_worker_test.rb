require 'test_helper'

class EvaluatedPromotionsWorkerTest < ActiveSupport::TestCase

  setup do
    @worker = EvaluatedPromotionsWorker.new()
    @test_payload = {
      promotion_id: 1,
      organization_id: 2,
      evaluation_info:{
           result:{
                  applicable: true,
                  total_discounted: 100,
                  response_time: 1
            },
            demographic_data:{ 
                  birthdate: Date.new(1990, 5, 22),
                  city: 'montevideo',
                  country: 'uruguay' 	 
          }
       }
    }
  end

  test 'should update usage report when correct' do
    assert_no_difference('UsageReport.count') do
      @worker.work(@test_payload .to_json)
    end
    
    updated = UsageReport.find_by(promotion_id: 1)
    
    assert_equal(3,updated.invocations_count)
    assert_equal(1,updated.negative_responses_count)
    expected_average = (1+1)/3.0
    assert_in_delta(expected_average, updated.average_response_time, 0.01)
    assert_equal(250, updated.total_money_spent)

    # check only one report has been updated
    other = UsageReport.find_by(promotion_id: 2)

    assert_equal(1,other.invocations_count)
    assert_equal(1,other.negative_responses_count)
    assert_equal(0.2, other.average_response_time)
    assert_equal(0, other.total_money_spent)
  end

  test 'should update counts by age, country and city' do

    assert_no_difference('CountByAgeRange.count') do
      @worker.work(@test_payload .to_json)
    end

    ages = CountByAgeRange.find_by(promotion_id: 1, age_range_id: 2)
    country = CountByCountry.find_by(promotion_id: 1, country_id: 1)
    city = CountByCity.find_by(promotion_id: 1, city_id: 1)

    # ages asserts
    assert_equal(2,ages.count)
    assert_equal(2, country.count)
    assert_equal(2, city.count)

  end

  test 'should not update if some id missing' do

    payload1 = @test_payload.except(:promotion_id)

    assert_no_difference('CountByAgeRange.count') do
      @worker.work(payload1.to_json)
    end

    payload2 = @test_payload.except(:organization_id)

    assert_no_difference('CountByAgeRange.count') do
      @worker.work(payload2.to_json)
    end
  end

  test 'should not update demographic data if not provided' do
    payload = @test_payload
    payload[:evaluation_info].delete(:demographic_data)
    @worker.work(payload.to_json)

    usage = usage_reports(:one)

    assert_equal(3,usage.invocations_count)
    assert_equal(1,usage.negative_responses_count)
    expected_average = (1+1)/3.0
    assert_in_delta(expected_average, usage.average_response_time, 0.01)
    assert_equal(250, usage.total_money_spent)

    age = count_by_age_ranges(:one)
    city = count_by_cities(:one)
    country = count_by_countries(:one)

    assert_equal(1, age.count)
    assert_equal(1, country.count)
    assert_equal(1, city.count)
  end

  test 'should update only demographic fields available' do
    # if country is not provided, city wont be taken into account
    @test_payload[:evaluation_info][:demographic_data].delete(:country)
    assert_no_difference('CountByAgeRange.count') do
      @worker.work(@test_payload .to_json)
    end

    ages = CountByAgeRange.find_by(promotion_id: 1, age_range_id: 2)
    country = CountByCountry.find_by(promotion_id: 1, country_id: 1)
    city = CountByCity.find_by(promotion_id: 1, city_id: 1)

    # ages asserts
    assert_equal(2,ages.count)
    assert_equal(1, country.count)
    assert_equal(1, city.count)

  end

end