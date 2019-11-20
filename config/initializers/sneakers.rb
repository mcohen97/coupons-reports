Sneakers.configure :amqp => ENV['QUEUE_SERVER_HOST'],
                   :durable => false

Sneakers.logger.level = Logger::INFO # the default DEBUG is too noisy