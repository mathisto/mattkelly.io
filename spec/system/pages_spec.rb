require 'rails_helper'

RSpec.describe 'Pages', type: :system do
  it 'serves static pages' do
    # Home page
    visit root_path
    expect(page).to have_current_path(root_path)

    # Projects page
    visit projects_path
    expect(page).to have_current_path(projects_path)

    # CV page
    visit cv_path
    expect(page).to have_current_path(cv_path)
  end
end 