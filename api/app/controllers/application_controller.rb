class ApplicationController < ActionController::API
  Rack::Utils::SYMBOL_TO_STATUS_CODE.keys.each do |status|
    define_method "render_#{status}" do |json|
      render json: json, status: status
    end
  end
end
