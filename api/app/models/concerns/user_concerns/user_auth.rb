module UserConcerns
  module UserAuth
    extend ActiveSupport::Concern

    AUTH_EXPIRATION_DURATION = 5.minutes
    VALID_NONCE_REGEXP = Regexp.new(
      '\A(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/]{2}==|[A-Za-z0-9+/]{3}=)?\z'
    ).freeze

    included do
      before_create :assign_salt

      validate :validate_salt_not_changed

      validates :nonce, format: { with: VALID_NONCE_REGEXP }
      validates :ckey, format: { with: AuthServices::CipherService::VALID_KEY_REGEXP }
      validates :civ, format: { with: AuthServices::CipherService::VALID_IV_REGEXP }
    end

    def refresh_auth
      new_nonce = SecureRandom.base64
      new_ckey = AuthServices::CipherService.random_key
      new_civ = AuthServices::CipherService.random_iv
      expiration = AUTH_EXPIRATION_DURATION.from_now

      update nonce: new_nonce, ckey: new_ckey, civ: new_civ, auth_expires_at: expiration
    end

    private

    def assign_salt
      self.salt = BCrypt::Engine.generate_salt
    end

    def validate_salt_not_changed
      return unless will_save_change_to_salt? && persisted?

      errors.add :salt, 'Change of salt not allowed!'
    end
  end
end
