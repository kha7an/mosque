module PrayerTimes
  class SchedulePresenter
    Entry = Data.define(:key, :name, :time, :subtitle, :active)

    def self.for(city:, date: Time.zone.today)
      new(city:, date:).call
    end

    def initialize(city:, date:)
      @city = city
      @date = date.to_date
      @schedule = @city&.prayer_times&.find_by(date: @date)
    end

    def call
      return empty_schedule unless @schedule

      active_key = active_prayer_key
      entries = PrayerTime::PRAYER_KEYS.map do |key|
        Entry.new(
          key:,
          name: I18n.t("prayer_times.names.#{key}"),
          time: @schedule.formatted_time(key),
          subtitle: subtitle_for(key),
          active: key == active_key
        )
      end

      {
        city_name: @city.name,
        date: @date,
        date_label: I18n.l(@date, format: :long),
        entries:,
        next_prayer: next_prayer_entry,
        source_url: DumrtClient::PAGE_URL
      }
    end

    private

    def empty_schedule
      {
        city_name: @city&.name,
        date: @date,
        date_label: I18n.l(@date, format: :long),
        entries: [],
        next_prayer: nil,
        source_url: DumrtClient::PAGE_URL
      }
    end

    def subtitle_for(key)
      case key
      when :sunrise
        I18n.t("prayer_times.subtitles.sunrise")
      else
        I18n.t("prayer_times.subtitles.beginning")
      end
    end

    def prayer_moments
      PrayerTime::PRAYER_KEYS.filter_map do |key|
        moment = @schedule.datetime_for(key)
        [ key, moment ] if moment
      end
    end

    def active_prayer_key
      now = Time.zone.now
      return unless @date == now.to_date

      active = prayer_moments.first&.first
      prayer_moments.each do |key, moment|
        active = key if moment <= now
      end
      active
    end

    def next_prayer_entry
      now = Time.zone.now
      return unless @date == now.to_date

      upcoming = prayer_moments.find { |_, moment| moment > now }
      if upcoming
        key, moment = upcoming
        return {
          name: I18n.t("prayer_times.names.#{key}"),
          time: moment.strftime("%H:%M")
        }
      end

      tomorrow = @city.prayer_times.find_by(date: @date + 1.day)
      return unless tomorrow&.fajr

      {
        name: I18n.t("prayer_times.names.fajr"),
        time: tomorrow.formatted_time(:fajr)
      }
    end
  end
end
