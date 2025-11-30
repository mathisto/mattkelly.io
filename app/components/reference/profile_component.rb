class Reference::ProfileComponent < ApplicationComponent
  def initialize(name:, title:, image:, url:, position: :left, **options)
    @name = name
    @title = title
    @image = image
    @url = url
    @position = position
    @options = options
  end

  private

  def profile_classes
    classes = [ "profile-section" ]
    classes << "right" if @position == :right
    classes.join(" ")
  end
end
