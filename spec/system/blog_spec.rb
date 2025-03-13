require 'rails_helper'

RSpec.describe 'Blog', type: :system do
  describe 'Blog pages' do
    before do
      visit "/blog"
    end

    it 'can visit the blog index' do
      expect(page).to have_content('Blog')
    end

    it 'can view a blog post' do
      click_link "Read More"
      expect(page).to have_css('article', wait: 5)
    end

    it 'shows markdown content properly formatted' do
      click_link "Read More"
      expect(page).to have_css('article', wait: 5)
      expect(page).to have_css('.heading-2', text: 'The Tech Stack', wait: 5)
      expect(page).to have_css('p', wait: 5)
      expect(page).to have_css('ul', wait: 5)
      expect(page).to have_css('li', wait: 5)
      expect(page).to have_css('pre code', wait: 5)
    end
  end
end 