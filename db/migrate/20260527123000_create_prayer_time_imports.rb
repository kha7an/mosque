class CreatePrayerTimeImports < ActiveRecord::Migration[8.0]
  def change
    create_table :prayer_time_imports do |t|
      t.integer :year, null: false
      t.string :source_url, null: false
      t.integer :cities_count, null: false, default: 0
      t.integer :rows_imported, null: false, default: 0
      t.datetime :completed_at

      t.timestamps
    end

    add_index :prayer_time_imports, :year, unique: true
  end
end
