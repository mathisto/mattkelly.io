require 'rails_helper'

RSpec.describe Project, type: :model do
  describe "validations" do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:technologies_used) }
    it { should validate_presence_of(:position) }
    it { should validate_numericality_of(:position).only_integer }
  end

  describe "URL validations" do
    it { should allow_value('https://github.com/example').for(:github_url) }
    it { should allow_value('https://example.com').for(:live_site_url) }
    it { should allow_value('https://example.com/image.png').for(:screenshot_url) }
    it { should_not allow_value('not-a-url').for(:github_url) }
    it { should allow_value(nil).for(:github_url) }
    it { should allow_value('').for(:github_url) }
  end

  describe "scopes" do
    let!(:highlighted_project) { create(:project, :highlighted, position: 2) }
    let!(:regular_project) { create(:project, position: 1) }
    let!(:github_project) { create(:project, :with_github, position: 3) }
    let!(:live_site_project) { create(:project, :with_live_site, position: 4) }

    describe ".highlighted" do
      it "returns only highlighted projects in position order" do
        expect(Project.highlighted).to eq([highlighted_project])
      end
    end

    describe ".ordered" do
      it "returns all projects in position order" do
        expect(Project.ordered).to eq([regular_project, highlighted_project, github_project, live_site_project])
      end
    end

    describe ".with_github" do
      it "returns only projects with github URLs" do
        expect(Project.with_github).to eq([github_project])
      end
    end

    describe ".with_live_site" do
      it "returns only projects with live site URLs" do
        expect(Project.with_live_site).to eq([live_site_project])
      end
    end
  end

  describe "position assignment" do
    it "automatically assigns the next available position" do
      first_project = create(:project)
      second_project = create(:project)
      expect(second_project.position).to eq(first_project.position + 1)
    end

    it "allows manual position assignment" do
      project = create(:project, position: 100)
      expect(project.position).to eq(100)
    end
  end

  describe "technologies_used" do
    it "serializes as an array" do
      project = create(:project, technologies_used: ["Ruby", "Rails"])
      project.reload
      expect(project.technologies_used).to eq(["Ruby", "Rails"])
    end
  end
end
