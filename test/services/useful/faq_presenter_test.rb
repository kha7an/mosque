require "test_helper"

class Useful::FaqPresenterTest < ActiveSupport::TestCase
  test "sections include naming and nikah" do
    sections = Useful::FaqPresenter.sections

    assert_equal 2, sections.size
    assert_equal "naming", sections.first.id
    assert_equal "nikah", sections.second.id
    assert sections.first.items.any?
    assert_equal "/nikah", sections.second.cta_path
  end
end
