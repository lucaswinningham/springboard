module Activatable
  extend ActiveSupport::Concern
  extend ActiveModel::Callbacks
  included do
    define_model_callbacks :activate
    define_model_callbacks :deactivate
  end

  def activate
    run_callbacks :activate do
      update activated_at: Time.now.utc, active: true
    end
  end

  def deactivate
    run_callbacks :deactivate do
      update deactivated_at: Time.now.utc, active: false
    end
  end
end
