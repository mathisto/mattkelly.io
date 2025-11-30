class TestSolidJob < ApplicationJob
  queue_as :default

  def perform(message)
    Rails.logger.info "✅ SolidQueue is working! Message: #{message}"
  end
end
