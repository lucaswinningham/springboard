class ApplicationController < ActionController::API
  Rack::Utils::SYMBOL_TO_STATUS_CODE.keys.each do |status|
    define_method "render_#{status}" do |json|
      render json: json, status: status
    end
  end

  private

  def find_user!
    render_not_found user_name: user_name unless user
  end

  def user
    @user ||= User.find_by_name user_name
  end

  def user_name
    params[:user_name]
  end
end
