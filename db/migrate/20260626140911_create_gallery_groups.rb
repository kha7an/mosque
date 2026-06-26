class CreateGalleryGroups < ActiveRecord::Migration[8.0]
  def change
    create_table :gallery_groups do |t|
      t.string :title, null: false
      t.string :slug, null: false
      t.text :description
      t.integer :position

      t.timestamps
    end
    add_index :gallery_groups, :slug, unique: true
  end
end
