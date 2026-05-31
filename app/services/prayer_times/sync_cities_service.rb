module PrayerTimes
  class SyncCitiesService
    def self.call
      new.call
    end

    def initialize(client: DumrtClient.new)
      @client = client
    end

    def call
      @client.fetch_cities.filter_map do |entry|
        slug = entry[:source_filename].sub(/\.csv\z/i, "").underscore
        city = City.find_or_initialize_by(slug:)
        city.assign_attributes(
          name: entry[:name],
          source_filename: entry[:source_filename]
        )
        city.save!
        city
      end
    end
  end
end
