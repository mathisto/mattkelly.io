class Navigation::SocialLinksComponent < ApplicationComponent
  SOCIAL_LINKS = [
    { icon: "github", url: "https://github.com/mathisto", label: "GitHub", style: :brands },
    { icon: "linkedin", url: "https://www.linkedin.com/in/themattkellyshow/", label: "LinkedIn", style: :brands },
    { icon: "envelope", url: "mailto:matthew.ryan.kelly@gmail.com", label: "Email", style: :solid }
  ].freeze

  def social_links
    SOCIAL_LINKS
  end
end
