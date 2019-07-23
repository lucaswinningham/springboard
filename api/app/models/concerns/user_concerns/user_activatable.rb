module UserConcerns
  module UserActivatable
    extend ActiveSupport::Concern

    included do
      include Activatable

      after_create :trigger_activation
      before_deactivate :deactivate_associations
    end

    attr_reader :activation_token

    def trigger_activation
      refresh_activation
      send_activation_email
    end

    private

    def refresh_activation
      @activation_token = SecureRandom.hex
      new_activation_digest = BCrypt::Password.create activation_token
      update activation_digest: new_activation_digest
    end

    def send_activation_email
      Mailers::UserMailers::ActivationMailer.new(self).deliver
    end

    def deactivate_associations; end
  end
end
