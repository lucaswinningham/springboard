module UserConcerns
  module UserActivatable
    extend ActiveSupport::Concern

    included do
      include Activatable

      before_create :refresh_activation
      before_deactivate :deactivate_associations
    end

    attr_reader :activation_token

    def refresh_activation
      @activation_token = SecureRandom.hex
      self.activation_digest = BCrypt::Password.create activation_token
    end

    private

    def deactivate_associations; end
  end
end
