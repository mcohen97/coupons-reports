class EvaluatedPromotionsWorker
  include Sneakers::Worker
  # env is set to nil since by default the actual queue name would have the env appended to the end
  from_queue ENV['EVALUATED_PROMOTIONS_QUEUE'],
                env: nil,
                durable: true

  # work method receives message payload in raw format
  # in our case it is JSON encoded string
  # which we can pass to service without
  # changes
  def work(raw_data)
    raw_data = JSON.parse(raw_data)
    id = raw_data['promotion_id']
    org_id = raw_data['organization_id']
    payload = raw_data['evaluation_info']

    pass_data_to_service(payload, id, org_id) if correct_data_provided(raw_data)
    ack! # we need to let queue know that message was received
  end

  def pass_data_to_service(payload, id, org_id)
    # Use DTO to make code inside the app more clean and mantainable
    dto = EvaluatedPromotionPayload.new(payload)
    Services.report_data_calculator.update_promotion_report(dto, id, org_id)
  end

  def correct_data_provided(raw_data)
    return !raw_data['promotion_id'].nil? && !raw_data['evaluation_info'].nil?
  end

end