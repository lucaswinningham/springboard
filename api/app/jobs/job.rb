class Job
  def self.enqueue(**kwargs)
    return if Rails.env.test?

    queue_name = kwargs[:queue]
    payload = kwargs[:payload].to_json

    connection = Bunny.new.tap(&:start)
    channel = connection.create_channel
    queue = channel.queue queue_name, durable: true

    log queue: queue_name, payload: payload

    queue.publish payload
    connection.close
  end

  class << self
    private

    def log(queue:, payload:)
      Rails.logger.info " [BUNNY] #{queue}:"
      Rails.logger.ap JSON.parse(payload), :info
    end
  end
end
