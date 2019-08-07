module AuthServices
  class JwtService
    def self.to_payload(user:)
      now = Time.now.utc.to_i

      {
        sub: user.name,
        iat: now,
        nbf: now,
        exp: (now + 2.hours).to_i
      }
    end

    def self.encode(payload:, secret:)
      JWT.encode payload, secret
    end

    def self.decode(token:, secret:)
      JWT.decode(token, secret).first.symbolize_keys
    rescue JWT::DecodeError
      nil
    end

    def self.random_key
      SecureRandom.hex
    end
  end
end
