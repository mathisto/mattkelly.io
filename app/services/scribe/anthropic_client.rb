require "net/http"
require "json"

module Scribe
  class AnthropicClient
    API_URL = "https://api.anthropic.com/v1/messages".freeze
    API_VERSION = "2023-06-01".freeze

    # Model constants
    MODEL_HAIKU = "claude-3-5-haiku-20241022".freeze
    MODEL_SONNET = "claude-3-7-sonnet-20250219".freeze

    def initialize(api_key: ENV["ANTHROPIC_API_KEY"])
      @api_key = api_key
      raise "ANTHROPIC_API_KEY not set" unless @api_key
    end

    # Main entry point for sending messages
    def send_message(prompt:, system_prompt: nil, model: MODEL_HAIKU, max_tokens: 1024, temperature: 0.3)
      payload = build_payload(
        prompt: prompt,
        system_prompt: system_prompt,
        model: model,
        max_tokens: max_tokens,
        temperature: temperature
      )

      response = make_request(payload)
      parse_response(response)
    end

    private

    def build_payload(prompt:, system_prompt:, model:, max_tokens:, temperature:)
      payload = {
        model: model,
        max_tokens: max_tokens,
        temperature: temperature,
        messages: [
          {
            role: "user",
            content: prompt
          }
        ]
      }

      payload[:system] = system_prompt if system_prompt.present?
      payload
    end

    def make_request(payload)
      uri = URI(API_URL)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.read_timeout = 30

      request = Net::HTTP::Post.new(uri.path)
      request["Content-Type"] = "application/json"
      request["x-api-key"] = @api_key
      request["anthropic-version"] = API_VERSION
      request.body = payload.to_json

      response = http.request(request)

      unless response.is_a?(Net::HTTPSuccess)
        error_body = JSON.parse(response.body) rescue {}
        error_message = error_body.dig("error", "message") || response.message
        raise "Anthropic API error: #{error_message} (#{response.code})"
      end

      JSON.parse(response.body)
    rescue JSON::ParserError => e
      raise "Failed to parse Anthropic response: #{e.message}"
    rescue StandardError => e
      raise "Anthropic API request failed: #{e.message}"
    end

    def parse_response(response_data)
      {
        content: extract_text_content(response_data),
        model: response_data["model"],
        usage: {
          input_tokens: response_data.dig("usage", "input_tokens"),
          output_tokens: response_data.dig("usage", "output_tokens"),
          total_tokens: response_data.dig("usage", "input_tokens").to_i +
                       response_data.dig("usage", "output_tokens").to_i
        },
        stop_reason: response_data["stop_reason"]
      }
    end

    def extract_text_content(response_data)
      content_blocks = response_data["content"] || []
      text_blocks = content_blocks.select { |block| block["type"] == "text" }
      text_blocks.map { |block| block["text"] }.join("\n")
    end
  end
end
