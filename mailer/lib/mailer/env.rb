module Mailer
  class Env
    def self.production?
      ENV['ENVIRONMENT'] == 'production'
    end

    def self.app_email
      "#{ENV['GMAIL_USERNAME']}@gmail.com"
    end
  end
end
