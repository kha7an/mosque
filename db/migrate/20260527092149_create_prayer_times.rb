class CreatePrayerTimes < ActiveRecord::Migration[8.0]
  def change
    create_table :prayer_times do |t|
      t.references :city, null: false, foreign_key: true
      t.date :date, null: false
      t.time :end_suhur
      t.time :fajr, null: false
      t.time :sunrise
      t.time :zenith
      t.time :zuhr, null: false
      t.time :asr, null: false
      t.time :maghrib, null: false
      t.time :isha, null: false
      t.time :jumua

      t.timestamps
    end

    add_index :prayer_times, [ :city_id, :date ], unique: true
  end
end
