class Animations::SlideUpComponentPreview < Lookbook::Preview
  # Default slide up
  # ----------------
  # Element slides up from below as it enters viewport
  def default
    render Animations::SlideUpComponent.new do
      <<~HTML.html_safe
        <div class="bg-[#1f2335] p-8 rounded-lg border border-[#29293f]">
          <h3 class="text-[#7aa2f7] text-xl font-semibold mb-2">Slide Up Element</h3>
          <p class="text-[#a9b1d6]">This element slides up when scrolled into view.</p>
        </div>
      HTML
    end
  end

  # With delay
  # ----------
  # Animation delayed by 300ms
  # @param delay number "Animation delay in milliseconds"
  def with_delay(delay: 300)
    render Animations::SlideUpComponent.new(delay: delay) do
      <<~HTML.html_safe
        <div class="bg-[#1f2335] p-8 rounded-lg border border-[#29293f]">
          <h3 class="text-[#7aa2f7] text-xl font-semibold mb-2">Delayed Slide Up</h3>
          <p class="text-[#a9b1d6]">Delay: #{delay}ms</p>
        </div>
      HTML
    end
  end

  # Card grid
  # ---------
  # Cards sliding up in sequence
  def card_grid
    render_with_template
  end
end
