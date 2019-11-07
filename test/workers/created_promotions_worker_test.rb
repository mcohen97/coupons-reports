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

end