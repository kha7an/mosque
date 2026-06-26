class RemoveDefaultFromGalleryPositions < ActiveRecord::Migration[8.0]
  def up
    change_column_default :gallery_groups, :position, nil
    change_column_null :gallery_groups, :position, true
    change_column_default :gallery_photos, :position, nil
    change_column_null :gallery_photos, :position, true

    GalleryGroup.reset_column_information
    GalleryPhoto.reset_column_information

    GalleryGroup.order(:position, :id).each_with_index do |group, index|
      group.update_column(:position, index)

      group.gallery_photos.order(:position, :id).each_with_index do |photo, photo_index|
        photo.update_column(:position, photo_index)
      end
    end
  end

  def down
    change_column_null :gallery_groups, :position, false
    change_column_default :gallery_groups, :position, 0
    change_column_null :gallery_photos, :position, false
    change_column_default :gallery_photos, :position, 0
  end
end
