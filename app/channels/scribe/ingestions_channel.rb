module Scribe
  class IngestionsChannel < ApplicationCable::Channel
    def subscribed
      stream_from "scribe_ingestions"
      Rails.logger.info "[IngestionsChannel] Client subscribed to scribe_ingestions"
    end

    def unsubscribed
      Rails.logger.info "[IngestionsChannel] Client unsubscribed from scribe_ingestions"
    end
  end
end
