module UserConcerns
  module UserAuth
    extend ActiveSupport::Concern

    AUTH_EXPIRATION_DURATION = 5.minutes

    included do
      before_create :assign_salt
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
  end
end
