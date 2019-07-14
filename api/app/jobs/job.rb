module Job
  def enqueue(**kwargs)
    return if Rails.env.test?

    queue_name = kwargs[:queue]
    payload = kwargs[:payload].to_json

    connection = Bunny.new.tap(&:start)
    channel = connection.create_channel
    queue = channel.queue queue_name, durable: true

    puts " [APP_INFO] #{queue_name}:"
    ap JSON.parse(payload)
    queue.publish payload
    connection.close
  end
end
