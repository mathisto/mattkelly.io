require "rails_helper"

RSpec.describe "utterances/edit", type: :view do
  let(:utterance) {
    Utterance.create!(
      text: "MyString",
      user_agent: "MyString"
    )
  }

  before(:each) do
    assign(:utterance, utterance)
  end

  it "renders the edit utterance form" do
    render

    assert_select "form[action=?][method=?]", utterance_path(utterance), "post" do
      assert_select "input[name=?]", "utterance[text]"

      assert_select "input[name=?]", "utterance[user_agent]"
    end
  end
end
