class Job
  def self.enqueue(**kwargs)
    return if Rails.env.test?

    queue_name = kwargs[:queue]
    payload = kwargs[:payload].to_json

    connection = Bunny.new.tap(&:start)
    channel = connection.create_channel
    queue = channel.queue queue_name, durable: true

    Rails.logger.info " [BUNNY] #{queue_name}:"
    Rails.logger.ap JSON.parse(payload), :info

    queue.publish payload
    connection.close
  end
end
