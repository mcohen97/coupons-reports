require 'test_helper'

class CreatedPromotionsWorkerTest < ActiveSupport::TestCase

  setup do
    @worker = CreatedPromotionsWorker.new()
  end

  test 'should call report data calculator' do
    payload = {
      promotion_id: 9,
      organization_id: 3
    }
    assert_difference('UsageReport.count') do
      @worker.work(payload.to_json)
    end
  end

  test 'should generate count registers for each age range' do
    payload = {
      promotion_id: 10,
      organization_id: 3
    }
    # three age ranges defined in fixture
    assert_difference('CountByAgeRange.count', 3) do
      @worker.work(payload.to_json)
    end
  end

  test 'should not allow repeated promotions' do
    payload = {
      promotion_id: 1,
      organization_id: 3
    }
    assert_no_difference('UsageReport.count') do
      @worker.work(payload.to_json)
    end
  end

  test "should not record promotions with out promo's or org's id" do
    payload = {
      promotion_id: 1
    }
    assert_no_difference('UsageReport.count') do
      @worker.work(payload.to_json)
    end
    payload = {
      organization_id: 3
    }
    assert_no_difference('UsageReport.count') do
      @worker.work(payload.to_json)
    end
  end

  
end