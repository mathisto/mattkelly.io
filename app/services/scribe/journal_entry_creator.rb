module Scribe
  class JournalEntryCreator
    attr_reader :content, :occurred_at

    def initialize(content:, occurred_at: nil)
      @content = content
      @occurred_at = occurred_at || Time.current
    end

    def create!
      JournalEntry.create!(
        content: content,
        occurred_at: occurred_at,
        original_utterance: content,
        confidence_score: 1.0 # Keyword-based entries have perfect confidence
      )
    end
  end
end
