class City < ApplicationRecord
  SLUG_OVERRIDES = {
    "Казань" => "kazan"
  }.freeze

  has_many :prayer_times, dependent: :destroy

  validates :name, :slug, presence: true
  validates :slug, uniqueness: true

  DEFAULT_FALLBACK_SLUG = "kazan"

  def self.default
    find_by(default: true) || find_by(slug: DEFAULT_FALLBACK_SLUG)
  end

  def self.slug_for(name)
    SLUG_OVERRIDES.fetch(name.strip) do
      name.strip.downcase.gsub(/[^\p{L}\p{N}]+/u, "_").gsub(/\A_|_\z/, "")
    end
  end
end
