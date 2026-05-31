module PrayerTimes
  module ValueParser
    EXCEL_EPOCH = Date.new(1899, 12, 30)

    module_function

    def parse_date(value)
      case value
      when Date
        value
      when Time, DateTime
        value.to_date
      when Numeric
        EXCEL_EPOCH + value.to_i
      else
        day, month, year = value.to_s.split(".")
        Date.new(year.to_i, month.to_i, day.to_i)
      end
    rescue ArgumentError, TypeError
      nil
    end

    def parse_time(value)
      return if value.blank?

      case value
      when Time, DateTime
        Time.zone.local(2000, 1, 1, value.hour, value.min)
      when Numeric
        total_minutes = ((value % 1) * 24 * 60).round
        hour, minute = total_minutes.divmod(60)
        Time.zone.local(2000, 1, 1, hour, minute)
      else
        hour, minute = value.to_s.strip.split(":").map(&:to_i)
        Time.zone.local(2000, 1, 1, hour, minute)
      end
    end
  end
end
