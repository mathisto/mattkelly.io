class ApplicationComponent < ViewComponent::Base
  include TokyoNightTokens

  def class_names(*classes)
    classes.compact.reject(&:empty?).join(" ")
  end

  def tokyo_color(name)
    TokyoNightTokens::COLORS[name.to_sym]
  end

  def rainbow_gradient
    TokyoNightTokens::GRADIENTS[:rainbow]
  end

  def border_gradient
    TokyoNightTokens::GRADIENTS[:border]
  end
end
