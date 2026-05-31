module PrayerTimes
  class ImportYearJob < ApplicationJob
    queue_as :default

    def perform(year = Time.zone.today.year)
      YearlyImportService.call(year:)
    end
  end
end
