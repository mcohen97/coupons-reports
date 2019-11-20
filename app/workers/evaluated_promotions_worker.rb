require './lib/error/invalid_promotion_data_error.rb'

class EvaluatedPromotionsWorker
  include Sneakers::Worker

  from_queue ENV['EVALUATED_PROMOTIONS_QUEUE'],
  amqp: ENV['QUEUE_SERVER_HOST'],
  exchange: ENV['EXCHANGE_TOPIC'],
  exchange_type: :topic,
  routing_key: ENV['EVALUATED_PROMOTIONS_BINDING_KEY'],
  env: nil,
  durable: true

  def work(raw_data)
    raw_data = JSON.parse(raw_data)

    id = raw_data['promotion_id']
    org_id = raw_data['organization_id']
    payload = raw_data['evaluation_info']

    pass_data_to_service(payload, id, org_id) if correct_data_provided(raw_data)
    
    Rails.logger.info("Promotion evaluated: #{raw_data.inspect}")
    
    ack!
  rescue JSON::ParserError, InvalidPromotionDataError => e
    Rails.logger.error(e.message)
  end

  def pass_data_to_service(payload, id, org_id)
    # Use DTO to make code inside the app more clean and mantainable
    dto = EvaluatedPromotionPayload.new(payload)
    Services.report_data_calculator.update_promotion_report(dto, id, org_id)
  end

  def correct_data_provided(raw_data)
    Rails.logger.error('Missing promotion ID') if raw_data['promotion_id'].nil?
    Rails.logger.error('Missing organization ID') if raw_data['organization_id'].nil?
    return !raw_data['promotion_id'].nil? && !raw_data['organization_id'].nil?
  end

end