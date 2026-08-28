class PagesController < ApplicationController
  def home
    @city = City.default
    @prayer_schedule = PrayerTimes::SchedulePresenter.for(city: @city)
    @hadith = Hadiths::DailyPresenter.for
    @videos = Video.published.sermons.limit(6)
    @video_categories = Video::SERMON_CATEGORIES
    feed = Event.homepage_feed(limit: 4)
    @featured_event = feed.find(&:featured?) || feed.first
    @upcoming_events = feed.reject { |event| event.id == @featured_event&.id }.first(3)
    @gallery_groups = GalleryGroup.ordered.includes(cover_photo: { image_attachment: :blob }).limit(3)
  end

  def about
  end

  def madrasa
  end

  def nikah
  end

  def useful
    @faq_sections = Useful::FaqPresenter.sections
    @dua_videos = Video.published.by_category("dua").load
    @useful_videos = Video.published.by_category("useful").load
    @show_video_modal = @dua_videos.any? || @useful_videos.any?
  end

  def contact
  end

  def privacy_policy
  end
end
