require 'rails_helper'

RSpec.describe Tutorial, type: :model do
  describe ".all" do
    it "loads all published tutorials from dragonruby directory" do
      tutorials = Tutorial.all

      expect(tutorials).to be_an(Array)
      expect(tutorials.all? { |t| t.status == "published" }).to be true
    end

    it "sorts tutorials by order" do
      tutorials = Tutorial.all

      if tutorials.length > 1
        expect(tutorials.first.order).to be <= tutorials.last.order
      end
    end
  end

  describe ".find" do
    it "finds tutorial by slug" do
      tutorial = Tutorial.find("001-hello-world")

      expect(tutorial).to be_a(Tutorial)
      expect(tutorial.slug).to eq("001-hello-world")
      expect(tutorial.title).to include("Hello World")
    end

    it "raises error when tutorial not found" do
      expect {
        Tutorial.find("nonexistent-tutorial")
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe ".from_file" do
    let(:tutorial) { Tutorial.find("001-hello-world") }

    it "parses frontmatter correctly" do
      expect(tutorial.title).to be_present
      expect(tutorial.description).to be_present
      expect(tutorial.difficulty).to eq("beginner")
      expect(tutorial.category).to eq("getting-started")
      expect(tutorial.order).to eq(1)
    end

    it "extracts starter code from ruby:starter blocks" do
      expect(tutorial.starter_code).to be_present
      expect(tutorial.starter_code).to include("def tick args")
    end

    it "sets slug from filename" do
      expect(tutorial.slug).to eq("001-hello-world")
    end
  end

  describe "#rendered_content" do
    let(:tutorial) { Tutorial.find("001-hello-world") }

    it "renders markdown to HTML" do
      html = tutorial.rendered_content

      expect(html).to include("<h1")
      expect(html).to be_present
    end

    it "applies syntax highlighting classes" do
      html = tutorial.rendered_content

      expect(html).to include("language-ruby")
    end
  end

  describe "validations" do
    it "validates difficulty is valid" do
      tutorial = Tutorial.new(
        title: "Test",
        content: "Content",
        difficulty: "invalid",
        status: "published"
      )

      expect(tutorial.valid?).to be false
      expect(tutorial.errors[:difficulty]).to be_present
    end

    it "validates status is valid" do
      tutorial = Tutorial.new(
        title: "Test",
        content: "Content",
        difficulty: "beginner",
        status: "invalid"
      )

      expect(tutorial.valid?).to be false
      expect(tutorial.errors[:status]).to be_present
    end
  end
end
