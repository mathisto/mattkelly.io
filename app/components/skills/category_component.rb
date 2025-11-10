class Skills::CategoryComponent < ApplicationComponent
  renders_many :skills, Skills::PillComponent

  def initialize(title:, description: nil, **options)
    @title = title
    @description = description
    @options = options
  end
end
