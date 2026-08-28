require "test_helper"

class VideoTest < ActiveSupport::TestCase
  test "valid with title and rutube link" do
    video = Video.new(
      title: "Хутба",
      link: "https://rutube.ru/video/7716bd3e665725c3c008ae7ab4ff02e2/"
    )
    assert video.valid?
    assert_equal "7716bd3e665725c3c008ae7ab4ff02e2", video.rutube_id
  end

  test "embed url for public video" do
    video = Video.new(link: "https://rutube.ru/video/abc123def456/")
    assert_equal "https://rutube.ru/play/embed/abc123def456", video.embed_url
  end

  test "embed url for private video" do
    video = Video.new(link: "https://rutube.ru/video/abc123/?p=secretkey")
    assert_equal "https://rutube.ru/play/embed/abc123/secretkey", video.embed_url
  end

  test "invalid without title" do
    video = Video.new(link: "https://rutube.ru/video/abc123/")
    assert_not video.valid?
    assert_includes video.errors.attribute_names, :title
  end

  test "invalid without link" do
    video = Video.new(title: "Test")
    assert_not video.valid?
    assert_includes video.errors.attribute_names, :link
  end

  test "invalid with non-rutube link" do
    video = Video.new(title: "Test", link: "https://example.com/video/1")
    assert_not video.valid?
    assert_includes video.errors[:link], I18n.t("activerecord.errors.models.video.attributes.link.invalid_rutube")
  end

  test "sermons scope excludes useful page categories" do
    Video.create!(title: "Хутба", link: "https://rutube.ru/video/7716bd3e665725c3c008ae7ab4ff02e2/", category: "khutba")
    Video.create!(title: "Дуа", link: "https://rutube.ru/video/7716bd3e665725c3c008ae7ab4ff02e2/", category: "dua")

    titles = Video.sermons.pluck(:title)

    assert_includes titles, "Хутба"
    assert_not_includes titles, "Дуа"
  end
end
