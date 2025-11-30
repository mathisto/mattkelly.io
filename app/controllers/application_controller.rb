class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # rescue_from ActionController::RoutingError, with: :not_found
  # rescue_from ActionController::BadRequest, with: :bad_request
  # rescue_from StandardError, with: :internal_server_error

  private

  def not_found
    render "errors/404", status: :not_found, layout: "application"
  end

  def internal_server_error(exception)
    Rails.logger.error "Internal Server Error: #{exception.class} - #{exception.message}"
    Rails.logger.error exception.backtrace.join("\n")
    render "errors/500", status: :internal_server_error, layout: "application"
  end

  def bad_request
    render "errors/400", status: :bad_request, layout: "application"
  end
end
