require "roo"

module PrayerTimes
  class XlsxParser
    HEADER_ROWS = 2

    def self.call(file_path)
      new(file_path).call
    end

    def initialize(file_path)
      @file_path = file_path
    end

    def call
      xlsx = Roo::Excelx.new(@file_path)
      sheet = xlsx.sheet(0)
      grouped = Hash.new { |rows, city| rows[city] = [] }

      ((HEADER_ROWS + 1)..sheet.last_row).each do |row_index|
        row = sheet.row(row_index)
        next if row.compact.empty?

        city_name = row[0].to_s.strip
        next if city_name.blank?

        parsed = build_row(row)
        grouped[city_name] << parsed if parsed
      end

      grouped
    end

    private

    def build_row(row)
      date = ValueParser.parse_date(row[1])
      fajr = ValueParser.parse_time(row[3])
      return if date.blank? || fajr.blank?

      Row.new(
        date:,
        end_suhur: ValueParser.parse_time(row[2]),
        fajr:,
        sunrise: ValueParser.parse_time(row[4]),
        zenith: ValueParser.parse_time(row[5]),
        zuhr: ValueParser.parse_time(row[6]),
        asr: ValueParser.parse_time(row[7]),
        maghrib: ValueParser.parse_time(row[8]),
        isha: ValueParser.parse_time(row[9]),
        jumua: ValueParser.parse_time(row[10])
      )
    end
  end
end
