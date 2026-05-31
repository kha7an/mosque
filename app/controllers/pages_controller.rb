class PagesController < ApplicationController
  def home
    @city = City.default
    @prayer_schedule = PrayerTimes::SchedulePresenter.for(city: @city)
    @hadith = Hadiths::DailyPresenter.for
    @videos = Video.published.limit(6)
    @video_categories = Video::CATEGORIES
    feed = Event.homepage_feed(limit: 4)
    @featured_event = feed.find(&:featured?) || feed.first
    @upcoming_events = feed.reject { |event| event.id == @featured_event&.id }.first(3)
  end
end
