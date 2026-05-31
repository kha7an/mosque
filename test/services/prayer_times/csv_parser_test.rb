require "test_helper"

class PrayerTimes::CsvParserTest < ActiveSupport::TestCase
  setup do
    @sample = <<~CSV
      26.05.2026;01:14;01:44;03:15;11:41;12:00;17:20;20:08;21:38
      01.01.2026;05:53;06:43;08:14;11:48;12:00;13:34;15:22;17:19;12:30
    CSV
  end

  test "parses DUM RT csv rows" do
    rows = PrayerTimes::CsvParser.call(@sample)

    assert_equal 2, rows.size

    first = rows.first
    assert_equal Date.new(2026, 5, 26), first.date
    assert_equal "01:44", first.fajr.strftime("%H:%M")
    assert_equal "12:00", first.zuhr.strftime("%H:%M")
    assert_equal "21:38", first.isha.strftime("%H:%M")

    second = rows.second
    assert_equal "12:30", second.jumua.strftime("%H:%M")
  end
end
