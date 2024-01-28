require "rails_helper"

RSpec.describe UtterancesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/utterances").to route_to("utterances#index")
    end

    it "routes to #new" do
      expect(get: "/utterances/new").to route_to("utterances#new")
    end

    it "routes to #show" do
      expect(get: "/utterances/1").to route_to("utterances#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/utterances/1/edit").to route_to("utterances#edit", id: "1")
    end

    it "routes to #create" do
      expect(post: "/utterances").to route_to("utterances#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/utterances/1").to route_to("utterances#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/utterances/1").to route_to("utterances#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/utterances/1").to route_to("utterances#destroy", id: "1")
    end
  end
end
