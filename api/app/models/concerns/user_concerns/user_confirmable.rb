module UserConcerns
  module UserConfirmable
    attr_reader :confirmation_token

    def confirm
      update confirmed_at: Time.now.utc
    end

    def trigger_confirmation
      return if confirmed_at

      refresh_confirmation
      send_confirmation_email
    end

    private

    def refresh_confirmation
      @confirmation_token = SecureRandom.hex
      new_confirmation_digest = BCrypt::Password.create confirmation_token
      update confirmation_digest: new_confirmation_digest
    end

    def send_confirmation_email
      Mailers::UserMailers::ConfirmationMailer.new(self).deliver
    end
  end
end
