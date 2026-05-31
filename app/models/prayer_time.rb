class PrayerTime < ApplicationRecord
  belongs_to :city

  validates :date, :fajr, :zuhr, :asr, :maghrib, :isha, presence: true
  validates :date, uniqueness: { scope: :city_id }

  scope :for_date, ->(date) { where(date: date) }
  scope :chronological, -> { order(:date) }

  PRAYER_KEYS = %i[fajr sunrise zuhr asr maghrib isha].freeze

  def time_for(prayer)
    public_send(prayer)
  end

  def datetime_for(prayer)
    time = time_for(prayer)
    return if time.blank?

    Time.zone.local(date.year, date.month, date.day, time.hour, time.min)
  end

  def formatted_time(prayer)
    time = time_for(prayer)
    return if time.blank?

    time.strftime("%H:%M")
  end
end
