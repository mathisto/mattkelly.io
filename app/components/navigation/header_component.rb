class Navigation::HeaderComponent < ApplicationComponent
  renders_one :home_link
  renders_one :navigation, Navigation::NavComponent
end
