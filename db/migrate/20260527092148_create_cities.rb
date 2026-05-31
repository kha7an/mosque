class CreateCities < ActiveRecord::Migration[8.0]
  def change
    create_table :cities do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.string :source_filename, null: false
      t.boolean :default, null: false, default: false

      t.timestamps
    end

    add_index :cities, :slug, unique: true
    add_index :cities, :default, unique: true, where: "\"default\" = true", name: "index_cities_on_default_true"
  end
end
