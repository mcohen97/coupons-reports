class CreatedPromotionsWorker
  include Sneakers::Worker
  # env is set to nil since by default the actual queue name would have the env appended to the end
  from_queue ENV['CREATED_PROMOTIONS_QUEUE'], 
  amqp: ENV['QUEUE_SERVER_HOST'],
  exchange: ENV['EXCHANGE_TOPIC'],
  exchange_type: :topic,
  routing_key: ENV['CREATED_PROMOTIONS_BINDING_KEY'],
  env: nil,
  durable: true


  # work method receives message payload in raw format
  # in our case it is JSON encoded string
  # which we can pass to service without
  # changes
  def work(raw_data)
    Rails.logger.info("Promotion created: #{raw_data.inspect}")
    raw_data = JSON.parse(raw_data)
    Services.report_data_calculator.create_promotions_report(raw_data['promotion_id'],raw_data['organization_id']) if correct_data_provided(raw_data)
    ack! # we need to let queue know that message was received
  end

  def correct_data_provided(raw_data)
    return !raw_data['promotion_id'].nil? && !raw_data['organization_id'].nil?
  end
end