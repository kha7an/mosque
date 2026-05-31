module PrayerTimes
  class YearlyImportService
    Result = Data.define(:year, :cities_count, :imported, :updated, :total)

    def self.call(year: Time.zone.today.year)
      new(year:).call
    end

    def initialize(year:, client: DumrtClient.new)
      @year = year.to_i
      @client = client
    end

    def call
      source_url = @client.excel_url_for(@year)
      file_path = @client.download(source_url)
      grouped_rows = XlsxParser.call(file_path)
      imported = 0
      updated = 0
      total = 0

      grouped_rows.each do |city_name, rows|
        city = find_or_create_city(city_name)
        result = UpsertService.call(city, rows)
        imported += result.imported
        updated += result.updated
        total += result.total
      end

      record_import!(source_url:, cities_count: grouped_rows.size, rows_imported: total)

      Result.new(
        year: @year,
        cities_count: grouped_rows.size,
        imported:,
        updated:,
        total:
      )
    ensure
      File.delete(file_path) if file_path && File.exist?(file_path)
    end

    private

    def find_or_create_city(name)
      slug = City.slug_for(name)
      city = City.find_or_initialize_by(slug:)
      city.name = name
      city.save!
      city
    end

    def record_import!(source_url:, cities_count:, rows_imported:)
      import = PrayerTimeImport.find_or_initialize_by(year: @year)
      import.update!(
        source_url:,
        cities_count:,
        rows_imported:,
        completed_at: Time.current
      )
    end
  end
end
