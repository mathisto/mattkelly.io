class HomeController < ApplicationController
  def index
    Rails.logger.info "GitHub API Token present?: #{ENV['GITHUB_API_TOKEN'].present?}"
    Rails.logger.info "GitHub API Token: #{ENV['GITHUB_API_TOKEN']&.first(4)}..." if ENV['GITHUB_API_TOKEN'].present?
    @github_data = fetch_github_data
  end

  private

  def fetch_github_data
    return nil unless ENV['GITHUB_API_TOKEN'].present?

    github_service = GithubService.new
    result = github_service.fetch_contributions('mathisto')
    Rails.logger.info "GitHub API Response: #{result.inspect}"
    result
  rescue StandardError => e
    Rails.logger.error "Failed to fetch GitHub contributions: #{e.message}"
    Rails.logger.error e.backtrace.join("\n")
    nil
  end
end
