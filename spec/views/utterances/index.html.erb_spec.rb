require "rails_helper"

RSpec.describe "utterances/index", type: :view do
  before(:each) do
    assign(:utterances, [
      Utterance.create!(
        text: "Text",
        user_agent: "User Agent"
      ),
      Utterance.create!(
        text: "Text",
        user_agent: "User Agent"
      )
    ])
  end

  it "renders a list of utterances" do
    render
    cell_selector = (Rails::VERSION::STRING >= "7") ? "div>p" : "tr>td"
    assert_select cell_selector, text: Regexp.new("Text".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("User Agent".to_s), count: 2
  end
end
