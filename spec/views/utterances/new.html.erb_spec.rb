require "rails_helper"

RSpec.describe "utterances/new", type: :view do
  before(:each) do
    assign(:utterance, Utterance.new(
      text: "MyString",
      user_agent: "MyString"
    ))
  end

  it "renders new utterance form" do
    render

    assert_select "form[action=?][method=?]", utterances_path, "post" do
      assert_select "input[name=?]", "utterance[text]"

      assert_select "input[name=?]", "utterance[user_agent]"
    end
  end
end
