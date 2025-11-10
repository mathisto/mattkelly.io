class Github::HeatmapComponent < ApplicationComponent
  def initialize(data: nil, username: nil, **options)
    @data = data
    @username = username
    @options = options
  end

  def self.lazy_frame(username)
    content_tag :turbo_frame, id: "github-heatmap-#{username}",
                               src: "/github/heatmap/#{username}",
                               loading: :lazy,
                               class: "block" do
      content_tag :div, class: "github-heatmap-skeleton p-6 text-center" do
        content_tag(:div, class: "text-[#7aa2f7]") do
          "Loading GitHub activity..."
        end
      end
    end
  end

  private

  def total_contributions
    @data&.dig(:total) || 0
  end

  def weeks_data
    @data&.dig(:contributions) || []
  end
end
