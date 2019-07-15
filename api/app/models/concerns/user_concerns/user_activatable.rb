module UserConcerns
  module UserActivatable
    extend ActiveSupport::Concern

    included do
      include Activatable

      before_create :assign_activation_digest

      before_deactivate :deactivate_associations
    end

    attr_reader :activation_token

    private

    def assign_activation_digest
      @activation_token = SecureRandom.hex
      self.activation_digest = BCrypt::Password.create activation_token
    end

    def deactivate_associations; end
  end
end
