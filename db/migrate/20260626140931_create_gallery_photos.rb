class CreateGalleryPhotos < ActiveRecord::Migration[8.0]
  def change
    create_table :gallery_photos do |t|
      t.references :gallery_group, null: false, foreign_key: true
      t.integer :position

      t.timestamps
    end
  end
end
