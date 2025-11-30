class Navigation::FooterComponent < ApplicationComponent
  renders_one :social_links, Navigation::SocialLinksComponent

  def current_year
    Time.current.year
  end
end
