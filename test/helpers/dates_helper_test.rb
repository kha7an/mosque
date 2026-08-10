require "test_helper"

class DatesHelperTest < ActionView::TestCase
  include DatesHelper

  test "academic_year_label follows september start" do
    assert_equal "2025/26", academic_year_label(Date.new(2026, 3, 15))
    assert_equal "2026/27", academic_year_label(Date.new(2026, 9, 1))
    assert_equal "2026/27", academic_year_label(Date.new(2026, 12, 31))
  end

  test "enrollment_academic_year_label switches in june" do
    assert_equal "2025/26", enrollment_academic_year_label(Date.new(2026, 5, 31))
    assert_equal "2026/27", enrollment_academic_year_label(Date.new(2026, 6, 1))
    assert_equal "2026/27", enrollment_academic_year_label(Date.new(2026, 8, 10))
    assert_equal "2026/27", enrollment_academic_year_label(Date.new(2026, 11, 1))
  end
end
