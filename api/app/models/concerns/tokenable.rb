module Tokenable
  extend ActiveSupport::Concern

  included do
    before_create :assign_token
  end

  private

  def assign_token
    self.token = SecureRandom.hex until unique_token?
  end

  def unique_token?
    token && self.class.find_by_token(token).nil?
  end
end
