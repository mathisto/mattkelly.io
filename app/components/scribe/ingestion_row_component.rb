# TODO: Add Lookbook preview for Scribe::IngestionRowComponent
module Scribe
  class IngestionRowComponent < ApplicationComponent
    def initialize(ingestion:, **options)
      @ingestion = ingestion
      @options = options
    end

    def call
      content_tag(:tr, id: dom_id(@ingestion), class: row_classes) do
        safe_join([
          utterance_cell,
          status_cell,
          model_cell,
          metrics_cell,
          actions_cell
        ])
      end
    end

    private

    def row_classes
      class_names(
        "border-b border-[#3b4261] hover:bg-[#24283b] transition-colors",
        @options[:class]
      )
    end

    def utterance_cell
      content_tag(:td, class: "px-4 py-3") do
        content_tag(:div, class: "text-sm text-[#c0caf5]") do
          truncate(@ingestion.raw_utterance, length: 60)
        end
      end
    end

    def status_cell
      content_tag(:td, class: "px-4 py-3") do
        render Scribe::BadgeComponent.new(
          text: @ingestion.status.titleize,
          color: @ingestion.status_badge_color
        )
      end
    end

    def model_cell
      content_tag(:td, class: "px-4 py-3 text-sm text-[#a9b1d6]") do
        @ingestion.model_display_name
      end
    end

    def metrics_cell
      content_tag(:td, class: "px-4 py-3 text-sm text-[#565f89]") do
        metrics = []
        metrics << "#{@ingestion.tokens_used} tokens" if @ingestion.tokens_used
        metrics << @ingestion.formatted_processing_time if @ingestion.formatted_processing_time

        safe_join(metrics.map { |m| content_tag(:div, m) })
      end
    end

    def actions_cell
      content_tag(:td, class: "px-4 py-3") do
        content_tag(:div, class: "flex items-center gap-2") do
          safe_join([
            view_button,
            retry_button
          ].compact)
        end
      end
    end

    def view_button
      link_to "View",
              scribe_ingestion_path(@ingestion),
              class: "text-[#7aa2f7] hover:text-[#7dcfff] text-sm"
    end

    def retry_button
      return unless @ingestion.retryable?

      button_to "Retry",
                retry_scribe_ingestion_path(@ingestion),
                method: :post,
                class: "text-[#e0af68] hover:text-[#e0c185] text-sm",
                data: { turbo_method: :post }
    end
  end
end
