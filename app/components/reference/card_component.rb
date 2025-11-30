class Reference::CardComponent < ApplicationComponent
  renders_one :profile, Reference::ProfileComponent

  def initialize(profile_position: :left, **options)
    @profile_position = profile_position
    @options = options
  end

  private

  def card_classes
    class_names(
      "reference-card",
      @options[:class]
    )
  end

  def flex_classes
    classes = [ "reference-flex" ]
    classes << (@profile_position == :right ? "flex-row-reverse" : "flex-row")
    classes.join(" ")
  end

  def profile_position_right?
    @profile_position == :right
  end
end
