FactoryBot.define do
  factory :project do
    sequence(:title) { |n| "Project #{n}" }
    description { "A fascinating project that showcases modern web development practices and innovative solutions." }
    technologies_used { ["Ruby on Rails", "PostgreSQL", "React", "TailwindCSS"] }
    role { "Lead Developer" }
    duration { "3 months" }
    github_url { "https://github.com/mathisto/example-project" }
    live_site_url { "https://example-project.com" }
    screenshot_url { "https://example-project.com/screenshot.png" }
    highlight { false }
    sequence(:position)

    trait :highlighted do
      highlight { true }
    end

    trait :with_github do
      github_url { "https://github.com/mathisto/#{title.parameterize}" }
    end

    trait :with_live_site do
      live_site_url { "https://#{title.parameterize}.com" }
    end

    trait :with_screenshot do
      screenshot_url { "https://#{title.parameterize}.com/screenshot.png" }
    end
  end
end
