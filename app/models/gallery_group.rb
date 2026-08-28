class GalleryGroup < ApplicationRecord
  has_many :gallery_photos, -> { order(:position) }, dependent: :destroy, inverse_of: :gallery_group
  has_one :cover_photo, -> { order(:position) }, class_name: "GalleryPhoto", inverse_of: :gallery_group

  validates :title, :slug, presence: true
  validates :slug, uniqueness: true, format: { with: /\A[a-z0-9-]+\z/, message: "латиницей, цифрами и дефисами" }

  before_validation :assign_position, on: :create

  scope :ordered, -> { order(:position) }

  private

  def assign_position
    self.position ||= (self.class.maximum(:position) || -1) + 1
  end
end
