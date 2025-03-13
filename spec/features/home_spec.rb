require 'rails_helper'

RSpec.describe 'Home page', type: :feature do
  it 'displays the welcome message' do
    visit root_path
    expect(page).to have_selector('h1', text: 'Matt Kelly')
  end
end 