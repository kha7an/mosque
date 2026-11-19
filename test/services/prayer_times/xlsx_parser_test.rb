require "test_helper"

class PrayerTimes::XlsxParserTest < ActiveSupport::TestCase
  test "reads Excel time cells alongside text, day fractions and empty cells" do
    schedule = PrayerTimes::XlsxParser.call(file_fixture("prayer_times.xlsx"))
    rows = schedule.fetch("Казань")
    assert_equal 1, rows.size

    row = rows.first
    assert_equal Date.new(2026, 1, 1), row.date
    assert_equal "05:30", row.fajr.strftime("%H:%M")
    assert_equal "07:15", row.sunrise.strftime("%H:%M")
    assert_equal "12:00", row.zuhr.strftime("%H:%M")
    assert_nil row.end_suhur
    assert_nil row.jumua
  end
end
