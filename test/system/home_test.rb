require "application_system_test_case"

class HomeTest < ApplicationSystemTestCase
  test "visiting the home page" do
    visit root_path
    assert_selector "h1", text: "Matt Kelly"
  end
end 