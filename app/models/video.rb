class Video < ApplicationRecord
  CATEGORIES = %w[khutba lecture tafsir tatar useful dua].freeze
  SERMON_CATEGORIES = %w[khutba lecture tafsir tatar].freeze
  USEFUL_PAGE_CATEGORIES = %w[useful dua].freeze

  RUTUBE_ID_PATTERN = %r{
    rutube\.ru/(?:video|play/embed)/
    (?<id>[a-z0-9]+)
  }ix

  validates :title, presence: true
  validates :link, presence: true
  validates :category, inclusion: { in: CATEGORIES }, allow_blank: true
  validate :link_must_be_rutube

  scope :published, -> { order(created_at: :desc) }
  scope :by_category, ->(category) { where(category: category) }
  scope :sermons, -> { where.not(category: USEFUL_PAGE_CATEGORIES) }

  def category_label
    return if category.blank?

    I18n.t("videos.categories.#{category}", default: category)
  end

  def rutube_id
    match = link.match(RUTUBE_ID_PATTERN)
    match&.[](:id)
  end

  def rutube_private_key
    return @rutube_private_key if defined?(@rutube_private_key)

    @rutube_private_key = begin
      uri = URI.parse(link)
      Rack::Utils.parse_query(uri.query)["p"]
    rescue URI::InvalidURIError
      nil
    end
  end

  def embed_url
    return unless rutube_id

    url = "https://rutube.ru/play/embed/#{rutube_id}"
    url = "#{url}/#{rutube_private_key}" if rutube_private_key.present?
    url
  end

  def thumbnail_url
    return unless rutube_id

    "https://pic.rutube.ru/#{rutube_id}.jpg?size=m"
  end

  def category_badge_class
    case category
    when "tatar" then "sermon__live sermon__live--tat"
    when "dua" then "sermon__live sermon__live--dua"
    when "useful" then "sermon__live sermon__live--useful"
    else "sermon__live"
    end
  end

  private

  def link_must_be_rutube
    return if link.blank?

    errors.add(:link, :invalid_rutube) if rutube_id.blank?
  end
end
