module UserConcerns
  module UserActivatable
    extend ActiveSupport::Concern
    included do
      include Activatable

      before_deactivate :deactivate_associations
      after_activate :activate_associations
    end

    private

    def deactivate_associations; end

    def activate_associations; end
  end
end
