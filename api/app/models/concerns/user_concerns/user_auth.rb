module UserConcerns
  module UserAuth
    AUTH_EXPIRATION_DURATION = 5.minutes

    VALID_NONCE_REGEXP = Regexp.new(
      '\A(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/]{2}==|[A-Za-z0-9+/]{3}=)?\z'
    ).freeze
    VALID_CKEY_REGEXP = AuthServices::CipherService::VALID_KEY_REGEXP
    VALID_CIV_REGEXP = AuthServices::CipherService::VALID_IV_REGEXP

    extend ActiveSupport::Concern
    included do
      validates :nonce, format: { with: VALID_NONCE_REGEXP }
      validates :ckey, format: { with: VALID_CKEY_REGEXP }
      validates :civ, format: { with: VALID_CIV_REGEXP }

      before_create :assign_jwt_key
      validate :validate_jwt_key_not_changed
    end

    attr_reader :jwt

    def refresh_auth
      new_nonce = SecureRandom.base64
      new_ckey = AuthServices::CipherService.random_key
      new_civ = AuthServices::CipherService.random_iv
      expiration = AUTH_EXPIRATION_DURATION.from_now.utc

      update nonce: new_nonce, ckey: new_ckey, civ: new_civ, auth_expires_at: expiration
    end

    def auth_expired?
      Time.now.utc > Time.at(auth_expires_at.to_i).utc
    end

    def refresh_jwt
      payload = AuthServices::JwtService.to_payload user: self
      @jwt = AuthServices::JwtService.encode payload: payload, secret: jwt_key
    end

    private

    def assign_jwt_key
      self.jwt_key = AuthServices::JwtService.random_key
    end

    def validate_jwt_key_not_changed
      return unless will_save_change_to_jwt_key? && persisted?

      errors.add :jwt_key, 'Change of jwt_key not allowed.'
    end
  end
end
