class GalleryPhoto < ApplicationRecord
  IMAGE_CONTENT_TYPES = %w[image/jpeg image/png image/webp].freeze

  belongs_to :gallery_group

  has_one_attached :image
  validate :acceptable_image

  before_validation :assign_position, on: :create

  scope :ordered, -> { order(:position) }

  private

  def assign_position
    self.position ||= (gallery_group&.gallery_photos&.maximum(:position) || -1) + 1
  end

  def acceptable_image
    return unless image.attached?

    errors.add(:image, :invalid_type) unless image.blob.content_type.in?(IMAGE_CONTENT_TYPES)
  end
end
