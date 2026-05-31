module PrayerTimes
  class ImportService
    Result = UpsertService::Result

    def self.call(city)
      new(city).call
    end

    def initialize(city, client: DumrtClient.new)
      @city = city
      @client = client
    end

    def call
      raise "CSV source is missing for #{@city.name}" if @city.source_filename.blank?

      rows = CsvParser.call(@client.fetch_csv(@city.source_filename))
      UpsertService.call(@city, rows)
    end
  end
end
