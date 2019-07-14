module UserConcerns
  module UserCallbacks
    extend ActiveSupport::Concern

    included do
      after_create :send_activation_email
    end

    private

    def send_activation_email
      Mailers::UserMailers::ActivationMailer.new(self).deliver
    end
  end
end
