class Layout::ContainerComponentPreview < Lookbook::Preview
  # Default container
  # -----------------
  # Standard max-width container
  def default
    render Layout::ContainerComponent.new do
      <<~HTML.html_safe
        <div class="bg-[#1f2335] p-8 rounded-lg border border-[#29293f]">
          <h3 class="text-[#7aa2f7] text-xl font-semibold mb-2">Container Content</h3>
          <p class="text-[#a9b1d6]">This content is centered with responsive padding.</p>
        </div>
      HTML
    end
  end

  # Narrow container
  # ----------------
  # Smaller max-width for focused content
  def narrow
    render Layout::ContainerComponent.new(max_width: "max-w-3xl") do
      <<~HTML.html_safe
        <div class="bg-[#1f2335] p-8 rounded-lg border border-[#29293f]">
          <h3 class="text-[#7aa2f7] text-xl font-semibold mb-2">Narrow Container</h3>
          <p class="text-[#a9b1d6]">Uses max-w-3xl for better readability.</p>
        </div>
      HTML
    end
  end

  # Wide container
  # --------------
  # Larger max-width for expansive layouts
  def wide
    render Layout::ContainerComponent.new(max_width: "max-w-7xl") do
      <<~HTML.html_safe
        <div class="bg-[#1f2335] p-8 rounded-lg border border-[#29293f]">
          <h3 class="text-[#7aa2f7] text-xl font-semibold mb-2">Wide Container</h3>
          <p class="text-[#a9b1d6]">Uses max-w-7xl for dashboard-style layouts.</p>
        </div>
      HTML
    end
  end
end
