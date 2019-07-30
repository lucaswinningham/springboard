module UserConcerns
  module UserPassword
    extend ActiveSupport::Concern
    included do
      before_create :assign_salt
      validate :validate_salt_not_changed
    end

    private

    def assign_salt
      self.salt = BCrypt::Engine.generate_salt
    end

    def validate_salt_not_changed
      return unless will_save_change_to_salt? && persisted?

      errors.add :salt, 'Change of salt not allowed.'
    end
  end
end
