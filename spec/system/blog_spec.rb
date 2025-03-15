require 'rails_helper'

RSpec.describe 'Blog', type: :system do
  it 'serves blog pages' do
    # Can view blog index
    visit "/blog"
    expect(page).to have_content('Blog')
    
    # Can view a blog post
    click_link "Read More"
    expect(page).to have_selector('article')
  end
end 