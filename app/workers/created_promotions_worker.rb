require './lib/error/invalid_promotion_data_error.rb'

class CreatedPromotionsWorker
  include Sneakers::Worker

  from_queue ENV['CREATED_PROMOTIONS_QUEUE'], 
  amqp: ENV['QUEUE_SERVER_HOST'],
  exchange: ENV['EXCHANGE_TOPIC'],
  exchange_type: :topic,
  routing_key: ENV['CREATED_PROMOTIONS_BINDING_KEY'],
  env: nil,
  durable: true

  def work(raw_data)
    raw_data = JSON.parse(raw_data)
    Services.report_data_calculator.create_promotions_report(raw_data['promotion_id'],raw_data['organization_id']) if correct_data_provided(raw_data)
    Rails.logger.info("Promotion created: #{raw_data.inspect}")
    ack!
  rescue JSON::ParserError, InvalidPromotionDataError => e
    Rails.logger.error(e.message)
  end

  def correct_data_provided(raw_data)
    return !raw_data['promotion_id'].nil? && !raw_data['organization_id'].nil?
  end
end