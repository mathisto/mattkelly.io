# frozen_string_literal: true

module Scribe
  class IngestionsTableComponent < ApplicationComponent
    def initialize(ingestions:, search: nil, **options)
      @ingestions = ingestions
      @search = search
      @options = options
    end
  end
end
