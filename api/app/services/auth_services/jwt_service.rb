module AuthServices
  class JwtService
    def self.to_payload(user:)
      now = Time.now.utc.to_i
      payload_timestamps = { iat: now, nbf: now, exp: (now + 2.hours).to_i }

      payload_timestamps.merge sub: user.name
    end

    def self.encode(payload:, secret:)
      JWT.encode payload, secret
    end

    def self.decode(token:, secret:, verify: true)
      JWT.decode(token, secret, verify).first.symbolize_keys
    rescue JWT::DecodeError
      nil
    end

    def self.random_key
      SecureRandom.hex
    end
  end
end
