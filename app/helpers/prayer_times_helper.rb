module PrayerTimesHelper
  def prayer_time_value(record, field)
    value = record.public_send(field)
    value&.strftime("%H:%M") || "-"
  end

  def prayertime_period_label(from_date, to_date)
    t(
      "prayer_times.page.period",
      from: l(from_date, format: :short),
      to: l(to_date, format: :short)
    )
  end
end
