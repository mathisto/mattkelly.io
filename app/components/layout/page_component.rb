class Layout::PageComponent < ApplicationComponent
  renders_one :hero
  renders_many :sections, Layout::SectionComponent

  def initialize(title: nil, **options)
    @title = title
    @options = options
  end

  def page_title
    @title || "MattKelly.io"
  end
end
