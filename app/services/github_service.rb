class GithubService
  include HTTParty
  base_uri 'https://api.github.com'

  def initialize
    @headers = {
      'Authorization' => "token #{ENV['GITHUB_API_TOKEN']}",
      'Content-Type' => 'application/json',
      'Accept' => 'application/vnd.github.v4+json'
    }
  end

  def fetch_contributions(username)
    query = <<~GRAPHQL
      query {
        user(login: "#{username}") {
          contributionsCollection {
            contributionCalendar {
              totalContributions
              weeks {
                contributionDays {
                  contributionCount
                  date
                }
              }
            }
          }
        }
      }
    GRAPHQL

    response = self.class.post('/graphql',
      body: { query: query }.to_json,
      headers: @headers
    )

    Rails.logger.info "GitHub API Response Status: #{response.code}"
    Rails.logger.info "GitHub API Response Body: #{response.body}"

    data = response.dig('data', 'user', 'contributionsCollection', 'contributionCalendar')
    return nil unless data

    {
      total: data['totalContributions'],
      contributions: data['weeks'].flat_map do |week|
        week['contributionDays'].map do |day|
          count = day['contributionCount']
          {
            count: count,
            date: day['date'],
            color: contribution_color(count)
          }
        end
      end
    }
  end

  private

  def contribution_color(count)
    case count
    when 0 then '#24283b'
    when 1 then '#7aa2f7'
    when 2 then '#7dcfff'
    when 3 then '#2ac3de'
    else '#73daca'
    end
  end
end 