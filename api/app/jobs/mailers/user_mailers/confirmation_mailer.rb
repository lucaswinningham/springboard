module Mailers
  module UserMailers
    class ConfirmationMailer
      attr_reader :user

      def initialize(user)
        @user = user
      end

      def deliver
        Job.enqueue queue: queue, payload: payload
      end

      private

      def queue
        'mailers.user.confirmation'
      end

      def payload
        { email: user.email, confirmation_link: confirmation_link }
      end

      def confirmation_link
        "#{ENV['CLIENT_URL']}/activate/#{user.name}/#{user.confirmation_token}"
      end
    end
  end
end
