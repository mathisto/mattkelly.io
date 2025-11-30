class Layout::GridComponentPreview < Lookbook::Preview
  # Two column grid
  # ---------------
  # Responsive 1-2 column layout
  def two_columns
    render Layout::GridComponent.new(columns: "grid-cols-1 md:grid-cols-2", gap: "gap-6") do
      <<~HTML.html_safe
        <div class="bg-[#1f2335] p-6 rounded-lg border border-[#29293f]">
          <h4 class="text-[#7aa2f7] font-semibold">Column 1</h4>
        </div>
        <div class="bg-[#1f2335] p-6 rounded-lg border border-[#29293f]">
          <h4 class="text-[#7aa2f7] font-semibold">Column 2</h4>
        </div>
      HTML
    end
  end

  # Three column grid
  # -----------------
  # Responsive 1-2-3 column layout
  def three_columns
    render Layout::GridComponent.new(
      columns: "grid-cols-1 md:grid-cols-2 lg:grid-cols-3",
      gap: "gap-6"
    ) do
      <<~HTML.html_safe
        #{(1..6).map { |i|
          <<~ITEM
            <div class="bg-[#1f2335] p-6 rounded-lg border border-[#29293f]">
              <h4 class="text-[#7aa2f7] font-semibold">Item #{i}</h4>
            </div>
          ITEM
        }.join}
      HTML
    end
  end

  # Card grid
  # ---------
  # Grid of cards with components
  def card_grid
    render_with_template
  end
end
