class ErrorsController < ApplicationController
  layout 'application'
  
  def not_found
    render template: 'errors/not_found_new', status: :not_found
  end
end