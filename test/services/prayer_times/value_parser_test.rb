require "test_helper"

class PrayerTimes::ValueParserTest < ActiveSupport::TestCase
  test "parses excel serial date" do
    date = PrayerTimes::ValueParser.parse_date(46_023)
    assert_equal Date.new(2026, 1, 1), date
  end

  test "parses dotted date and time strings" do
    date = PrayerTimes::ValueParser.parse_date("26.05.2026")
    time = PrayerTimes::ValueParser.parse_time("01:44")

    assert_equal Date.new(2026, 5, 26), date
    assert_equal "01:44", time.strftime("%H:%M")
  end
end
