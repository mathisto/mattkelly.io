require "rails_helper"

RSpec.describe "utterances/show", type: :view do
  before(:each) do
    assign(:utterance, Utterance.create!(
      text: "Text",
      user_agent: "User Agent"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Text/)
    expect(rendered).to match(/User Agent/)
  end
end
