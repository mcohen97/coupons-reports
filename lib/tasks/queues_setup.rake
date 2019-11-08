namespace :rabbitmq do
  desc "Setup routing"
  task :setup do
    require "bunny"

    connection = Bunny.new(host: ENV['EXCHANGE_SERVER_HOST'], port: ENV['EXCHANGE_SERVER_PORT'])
    connection.start
    channel = connection.create_channel

    # get or create exchange
    exchange = channel.topic("promotion_events")

    # get or create queue (note the durable setting)
    created_promos_queue = channel.queue("created_promotions", durable: true)
    evaluated_promos_queue = channel.queue("evaluated_promotions", durable: true)

    # bind queue to exchange
    created_promos_queue.bind(exchange, routing_key: 'promotion.created')
    evaluated_promos_queue.bind(exchange, routing_key: 'promotion.evaluated')

    connection.close
  end
end