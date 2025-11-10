require 'rails_helper'

RSpec.describe "DragonRuby Interactive Fiddle", type: :system do
  before do
    driven_by(:rack_test)
  end

  describe "index page" do
    it "displays tutorial listing" do
      visit dragonruby_path

      expect(page).to have_content("DragonRuby Interactive Fiddle")
      expect(page).to have_content("Beginner Tutorials")
      expect(page).to have_content("Hello World")
    end

    it "groups tutorials by difficulty" do
      visit dragonruby_path

      within ".difficulty-section" do
        expect(page).to have_css(".difficulty-header")
        expect(page).to have_css(".tutorial-card")
      end
    end

    it "displays tutorial metadata" do
      visit dragonruby_path

      within first(".tutorial-card") do
        expect(page).to have_css(".difficulty-badge")
        expect(page).to have_css(".meta-item", minimum: 2)
      end
    end
  end

  describe "tutorial show page" do
    it "displays tutorial content" do
      visit dragonruby_tutorial_path("001-hello-world")

      expect(page).to have_content("Hello World")
      expect(page).to have_content("Your First DragonRuby Program")
    end

    it "has split-pane interface" do
      visit dragonruby_tutorial_path("001-hello-world")

      expect(page).to have_css(".dragonruby-split-pane")
      expect(page).to have_css(".editor-pane")
      expect(page).to have_css(".canvas-pane")
      expect(page).to have_css(".resize-handle")
    end

    it "has editor controls" do
      visit dragonruby_tutorial_path("001-hello-world")

      within ".editor-controls" do
        expect(page).to have_button("Run")
        expect(page).to have_button("Reset")
      end
    end

    it "has breadcrumb navigation" do
      visit dragonruby_tutorial_path("001-hello-world")

      expect(page).to have_link("← Back to Tutorials")
    end

    it "displays tutorial rendered content" do
      visit dragonruby_tutorial_path("001-hello-world")

      within ".tutorial-content" do
        expect(page).to have_css(".prose")
        expect(page).to have_css("h1, h2, h3")
      end
    end
  end

  describe "navigation" do
    it "has DragonRuby link in main nav" do
      visit root_path

      within "nav" do
        expect(page).to have_link("DragonRuby", href: dragonruby_path)
      end
    end

    it "can navigate from index to tutorial" do
      visit dragonruby_path

      click_link "Hello World", match: :first

      expect(page).to have_current_path(dragonruby_tutorial_path("001-hello-world"))
      expect(page).to have_content("Your First DragonRuby Program")
    end

    it "can navigate back to index from tutorial" do
      visit dragonruby_tutorial_path("001-hello-world")

      click_link "← Back to Tutorials"

      expect(page).to have_current_path(dragonruby_path)
      expect(page).to have_content("DragonRuby Interactive Fiddle")
    end
  end
end
