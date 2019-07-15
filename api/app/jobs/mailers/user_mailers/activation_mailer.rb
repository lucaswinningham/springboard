module Mailers
  module UserMailers
    class ActivationMailer
      attr_reader :user

      def initialize(user)
        @user = user
      end

      def deliver
        Job.enqueue queue: queue, payload: payload
      end

      private

      def queue
        'mailers.user.activation'
      end

      def payload
        { email: user.email, activation_link: activation_link }
      end

      def activation_link
        # "#{ENV['CLIENT_URL']}/activations/#{user.name}/#{user.activation.token}"
      end
    end
  end
end
