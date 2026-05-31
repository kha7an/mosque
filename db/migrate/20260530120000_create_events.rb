class CreateEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :events do |t|
      t.string :title, null: false
      t.text :description
      t.datetime :starts_at, null: false
      t.string :location
      t.string :category
      t.boolean :featured, null: false, default: false
      t.string :link

      t.timestamps
    end

    add_index :events, :starts_at
    add_index :events, :featured
  end
end
