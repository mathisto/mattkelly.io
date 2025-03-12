class HealthController < ApplicationController
  def up
    render json: { status: 'ok' }, status: :ok
  end
end 