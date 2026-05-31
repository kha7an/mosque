module PrayerTimes
  class UpsertService
    Result = Data.define(:imported, :updated, :total)

    def self.call(city, rows)
      new(city, rows).call
    end

    def initialize(city, rows)
      @city = city
      @rows = rows
    end

    def call
      imported = 0
      updated = 0

      @rows.each do |row|
        next if row.date.blank? || row.fajr.blank?

        prayer_time = @city.prayer_times.find_or_initialize_by(date: row.date)
        prayer_time.assign_attributes(row.to_h.except(:date))
        prayer_time.new_record? ? imported += 1 : updated += 1
        prayer_time.save!
      end

      Result.new(imported:, updated:, total: @rows.size)
    end
  end
end
