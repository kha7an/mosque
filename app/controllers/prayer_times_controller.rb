class PrayerTimesController < ApplicationController
  PERIOD_DAYS = 30

  def index
    @cities = City.order(:name)
    @city = selected_city
    @from_date = selected_from_date
    @to_date = @from_date + (PERIOD_DAYS - 1).days
    @schedule = load_schedule
    @year = @from_date.year
    @period_days = PERIOD_DAYS
  end

  private

  def selected_city
    (params[:city].present? && City.find_by(slug: params[:city])) || default_city
  end

  def default_city
    City.default || @cities.first
  end

  def selected_from_date
    return Time.zone.today if params[:from].blank?

    Date.parse(params[:from])
  rescue ArgumentError
    Time.zone.today
  end

  def load_schedule
    return PrayerTime.none unless @city

    @city.prayer_times.where(date: @from_date..@to_date).chronological
  end
end
