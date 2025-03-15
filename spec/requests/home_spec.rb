require 'rails_helper'

RSpec.describe "Home", type: :request do
  it "serves the home page" do
    get "/"
    expect(response).to have_http_status(:success)
  end
end
