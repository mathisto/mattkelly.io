class Animations::FadeInComponentPreview < Lookbook::Preview
  # Default fade in
  # ---------------
  # Element fades in as it enters viewport
  def default
    render Animations::FadeInComponent.new do
      <<~HTML.html_safe
        <div class="bg-[#1f2335] p-8 rounded-lg border border-[#29293f]">
          <h3 class="text-[#7aa2f7] text-xl font-semibold mb-2">Fade In Element</h3>
          <p class="text-[#a9b1d6]">This element fades in when scrolled into view.</p>
        </div>
      HTML
    end
  end

  # With delay
  # ----------
  # Animation delayed by 200ms
  # @param delay number "Animation delay in milliseconds"
  def with_delay(delay: 200)
    render Animations::FadeInComponent.new(delay: delay) do
      <<~HTML.html_safe
        <div class="bg-[#1f2335] p-8 rounded-lg border border-[#29293f]">
          <h3 class="text-[#7aa2f7] text-xl font-semibold mb-2">Delayed Fade In</h3>
          <p class="text-[#a9b1d6]">Delay: #{delay}ms</p>
        </div>
      HTML
    end
  end

  # Staggered list
  # --------------
  # Multiple elements with incremental delays
  def staggered
    render_with_template
  end
end
