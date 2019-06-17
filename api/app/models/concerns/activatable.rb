module Activatable
  extend ActiveSupport::Concern
  extend ActiveModel::Callbacks

  included do
    define_model_callbacks :activate, only: :before
    define_model_callbacks :deactivate, only: :before
  end

  def activate
    run_callbacks :activate do
      update activated_at: Time.now, active: true
    end
  end

  def deactivate
    run_callbacks :deactivate do
      update deactivated_at: Time.now, active: false
    end
  end
end
