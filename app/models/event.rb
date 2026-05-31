class Event < ApplicationRecord
  CATEGORIES = %w[special khutba youth education community].freeze
  COVER_CONTENT_TYPES = %w[image/jpeg image/png image/webp image/gif].freeze

  has_one_attached :cover

  validates :title, presence: true
  validate :acceptable_cover
  validates :starts_at, presence: true
  validates :category, inclusion: { in: CATEGORIES }, allow_blank: true

  before_save :ensure_single_featured, if: :featured?

  scope :ordered, -> { order(:starts_at) }

  scope :upcoming, -> {
    where(starts_at: Time.zone.now.beginning_of_day..).ordered
  }

  scope :listed, -> {
    where(starts_at: 90.days.ago.beginning_of_day..).ordered
  }

  def category_label
    return if category.blank?

    I18n.t("events.categories.#{category}", default: category)
  end

  def day_label
    I18n.l(starts_at.to_date, format: :event_day)
  end

  def month_label
    I18n.l(starts_at.to_date, format: :event_month)
  end

  def meta_label
    [ time_label, location.presence ].compact.join(" · ")
  end

  def time_label
    starts_at.strftime("%H:%M")
  end

  def date_long_label
    I18n.l(starts_at.to_date, format: :long)
  end

  def date_heading_label
    "#{month_label} #{starts_at.year}"
  end

  # До 4 событий для главной: предстоящие + недавние прошедшие, если предстоящих мало
  def self.homepage_feed(limit: 4)
    upcoming_list = upcoming.to_a
    return upcoming_list if upcoming_list.size >= limit

    past_list = where(starts_at: 90.days.ago.beginning_of_day...Time.zone.now.beginning_of_day)
      .where.not(id: upcoming_list.map(&:id))
      .order(starts_at: :desc)
      .limit(limit - upcoming_list.size)
      .to_a

    upcoming_list + past_list
  end

  private

  def ensure_single_featured
    self.class.where(featured: true).where.not(id: id).update_all(featured: false)
  end

  def acceptable_cover
    return unless cover.attached?

    unless cover.blob.content_type.in?(COVER_CONTENT_TYPES)
      errors.add(:cover, :invalid_type)
    end
  end
end
