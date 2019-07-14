require 'sneakers'
require 'json'
require 'ostruct'
require 'awesome_print'

module Worker
  def self.included(base)
    base.class_eval do
      include Sneakers::Worker
    end
  end

  def work(message)
    @payload = JSON.parse message, object_class: OpenStruct
    log
    go
    ack!
  rescue StandardError => error
    log_error error
  end

  private

  attr_reader :payload

  def go
    raise NotImplementedError
  end

  def log
    puts
    puts " [APP_INFO] #{self.class.name}"
    ap payload
  end

  def log_error(error)
    puts
    puts " [APP_ERROR] #{self.class.name}"
    ap error
    ap error.message
    ap error.backtrace
  end
end
