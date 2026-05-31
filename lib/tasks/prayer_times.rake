namespace :prayer_times do
  desc "Import yearly prayer times from DUM RT Excel (default: current year)"
  task :import_year, [ :year ] => :environment do |_task, args|
    year = (args[:year].presence || Time.zone.today.year).to_i
    result = PrayerTimes::YearlyImportService.call(year:)

    puts "Year #{result.year}: #{result.cities_count} cities, #{result.imported} new, #{result.updated} updated (#{result.total} rows)"
  end

  desc "Sync cities list from DUM RT CSV page"
  task sync_cities: :environment do
    cities = PrayerTimes::SyncCitiesService.call
    puts "Synced #{cities.size} cities"
  end

  desc "Import prayer times for one city from CSV (legacy)"
  task :import, [ :slug ] => :environment do |_task, args|
    slug = args[:slug].presence || "kazan"
    city = City.find_by!(slug:)
    result = PrayerTimes::ImportService.call(city)

    puts "Imported #{result.imported}, updated #{result.updated}, total rows #{result.total} for #{city.name}"
  end
end
