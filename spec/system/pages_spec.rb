require 'rails_helper'

RSpec.describe 'Pages', type: :system do
  describe 'Navigation' do
    it 'can visit the home page' do
      visit root_path
      expect(page).to have_content('Matt Kelly')
      expect(page).to have_link('Blog')
      expect(page).to have_link('Projects')
      expect(page).to have_link('CV')
    end

    it 'can visit the projects page' do
      visit projects_path
      expect(page).to have_content('Projects')
    end

    it 'can visit the CV page' do
      visit cv_path
      expect(page).to have_content('Experience')
      expect(page).to have_content('Education')
    end
  end
end 