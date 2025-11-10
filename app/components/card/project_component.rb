class Card::ProjectComponent < ApplicationComponent
  def initialize(title:, description:, technologies: [], links: {}, **options)
    @title = title
    @description = description
    @technologies = Array(technologies)
    @links = links
    @options = options
  end

  private

  def card_classes
    class_names(
      "project-card relative group",
      "bg-[#1f2335]/80 backdrop-blur-sm rounded-lg p-6",
      "border border-transparent transition-all duration-300",
      "hover:-translate-y-1 hover:shadow-lg hover:shadow-[#7aa2f7]/10",
      @options[:class]
    )
  end

  def gradient_classes
    "absolute top-0 left-1 right-1 h-0.5 bg-gradient-to-r from-[#7aa2f7] via-[#bb9af7] to-[#7dcfff] opacity-0 group-hover:opacity-100 transition-opacity duration-300"
  end
end
