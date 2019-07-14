require 'mailer/workers/worker'
require 'mail'

module Workers
  module User
    class ActivationWorker
      include Worker
      from_queue 'mailers.user.activation'

      def go
        send_email
      end

      private

      def send_email
        mail = Mail.new
        mail.to = recipient
        mail.from = app_email
        mail.subject = 'Account activation'
        mail.html_part = html_part
        mail.deliver
      end

      def recipient
        if ENV['ENVIRONMENT'] == 'production'
          payload.email
        else
          app_email
        end
      end

      def app_email
        "#{ENV['GMAIL_USERNAME']}@gmail.com"
      end

      def html_part
        body = html

        Mail::Part.new do
          content_type 'text/html; charset=UTF-8'
          body body
        end
      end

      def html
        <<~HTML
          <h2>Thanks for signing up!</h2>
          <p>Please click the link below to activate your account.</p>
          <a href=\"#{payload.activation_link}\">#{payload.activation_link}</a>
        HTML
      end
    end
  end
end
