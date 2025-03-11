class ErrorsController < ApplicationController
  layout 'application'
  
  def not_found
    render template: 'errors/404', status: :not_found
  end
end