require 'dotenv/load'

module Mailer
  class Env
    def self.production?
      ENV['ENVIRONMENT'] == 'production'
    end

    def self.gmail_username
      ENV['GMAIL_USERNAME']
    end

    def self.gmail_password
      ENV['GMAIL_PASSWORD']
    end

    def self.amqp_url
      ENV['AMQP_URL']
    end

    def self.app_email
      "#{gmail_username}@gmail.com"
    end
  end
end
