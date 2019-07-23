module UserConcerns
  module UserIdentifiable
    extend ActiveSupport::Concern

    VALID_NAME_REGEXP = /\A[A-Za-z0-9_\-]+\Z/.freeze
    VALID_EMAIL_REGEXP = URI::MailTo::EMAIL_REGEXP

    included do
      validates(
        :name,
        presence: true,
        allow_blank: false,
        uniqueness: true,
        length: { minimum: 3, maximum: 20 },
        format: { with: VALID_NAME_REGEXP }
      )

      validates(
        :email,
        presence: true,
        allow_blank: false,
        uniqueness: true,
        format: { with: VALID_EMAIL_REGEXP }
      )
    end
  end
end
