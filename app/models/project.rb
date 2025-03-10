class Project < ApplicationRecord
  # Validations
  validates :title, presence: true
  validates :description, presence: true
  validates :technologies_used, presence: true
  validates :position, presence: true, numericality: { only_integer: true }
  
  # URL validations with optional presence
  validates :github_url, format: { with: URI::DEFAULT_PARSER.make_regexp }, allow_blank: true
  validates :live_site_url, format: { with: URI::DEFAULT_PARSER.make_regexp }, allow_blank: true
  validates :screenshot_url, format: { with: URI::DEFAULT_PARSER.make_regexp }, allow_blank: true

  # Scopes
  scope :highlighted, -> { where(highlight: true).order(position: :asc) }
  scope :ordered, -> { order(position: :asc) }
  scope :with_github, -> { where.not(github_url: [nil, '']) }
  scope :with_live_site, -> { where.not(live_site_url: [nil, '']) }

  # Serialize technologies_used as an array
  serialize :technologies_used, coder: JSON

  # Callbacks
  before_validation :ensure_position
  
  private

  def ensure_position
    self.position ||= (self.class.maximum(:position) || 0) + 1
  end
end
