class PrayerTimeImport < ApplicationRecord
  validates :year, :source_url, presence: true
  validates :year, uniqueness: true

  scope :latest, -> { order(year: :desc) }

  def completed?
    completed_at.present?
  end
end
