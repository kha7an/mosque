module PrayerTimes
  class CsvParser
    def self.call(csv_body)
      new(csv_body).call
    end

    def initialize(csv_body)
      @csv_body = csv_body
    end

    def call
      @csv_body.each_line.filter_map do |line|
        parse_line(line)
      end
    end

    private

    def parse_line(line)
      columns = line.strip.split(";")
      return if columns.size < 9

      Row.new(
        date: ValueParser.parse_date(columns[0]),
        end_suhur: ValueParser.parse_time(columns[1]),
        fajr: ValueParser.parse_time(columns[2]),
        sunrise: ValueParser.parse_time(columns[3]),
        zenith: ValueParser.parse_time(columns[4]),
        zuhr: ValueParser.parse_time(columns[5]),
        asr: ValueParser.parse_time(columns[6]),
        maghrib: ValueParser.parse_time(columns[7]),
        isha: ValueParser.parse_time(columns[8]),
        jumua: ValueParser.parse_time(columns[9])
      )
    end
  end
end
