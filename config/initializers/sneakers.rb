Sneakers.configure :amqp => ENV['QUEUE_SERVER_HOST'],
                   :exchange => ENV['EXCHANGE_TOPIC'],
                   :exchange_type => :topic,
                   :durable => false

Sneakers.logger.level = Logger::INFO # the default DEBUG is too noisy