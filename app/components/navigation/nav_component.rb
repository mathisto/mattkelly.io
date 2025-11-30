class Navigation::NavComponent < ApplicationComponent
  renders_many :links, Navigation::NavLinkComponent
end
