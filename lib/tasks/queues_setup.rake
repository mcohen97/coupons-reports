namespace :rabbitmq do
  desc "Setup routing"
  task :setup do
    require "bunny"

    connection = Bunny.new(host: ENV['EXCHANGE_SERVER_HOST'], port: ENV['EXCHANGE_SERVER_PORT'])
    connection.start
    channel = connection.create_channel

    # get or create exchange
    exchange = channel.topic(ENV['EXCHANGE_TOPIC'])

    # get or create queue (note the durable setting)
    created_promos_queue = channel.queue(ENV['CREATED_PROMOTIONS_QUEUE'], durable: true)
    evaluated_promos_queue = channel.queue(ENV['EVALUATED_PROMOTIONS_QUEUE'], durable: true)

    # bind queue to exchange
    created_promos_queue.bind(exchange, routing_key: ENV['CREATED_PROMOTIONS_BINDING_KEY'])
    evaluated_promos_queue.bind(exchange, routing_key: ENV['EVALUATED_PROMOTIONS_BINDING_KEY'])

    connection.close
  end
end