module UserConcerns
  module UserPassword
    extend ActiveSupport::Concern
    included do
      before_create :assign_salt
      validate :validate_salt_not_changed

      validate :validate_password_digest_does_not_change

      validate :validate_password
    end

    attr_accessor :password

    def password?(given_password)
      BCrypt::Password.new(password_digest).is_password? given_password
    end

    private

    def assign_salt
      self.salt = BCrypt::Engine.generate_salt
    end

    def validate_salt_not_changed
      return unless will_save_change_to_salt? && persisted?

      errors.add :salt, 'Change of salt not allowed.'
    end

    def validate_password_digest_does_not_change
      return unless will_save_change_to_password_digest?

      errors.add :password_digest, 'Change of password_digest not allowed.'
    end
  
    def validate_password
      return unless password

      if BCrypt::Password.valid_hash? password
        self.password_digest = BCrypt::Password.create password
      else
        errors.add :password, 'Invalid password format.'
      end
    end
  end
end
