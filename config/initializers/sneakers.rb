Sneakers.configure :amqp => "amqp://guest:guest@#{ENV['EXCHANGE_SERVER_HOST']}:#{ENV['EXCHANGE_SERVER_PORT']}",
                   :exchange => ENV['EXCHANGE_TOPIC'],
                   :exchange_type => :topic,
                   :durable => false

Sneakers.logger.level = Logger::INFO # the default DEBUG is too noisy