require "open3"
require "securerandom"
require "uri"

module PrayerTimes
  class DumrtClient
    BASE_URL = "https://dumrt.ru/netcat_files/391/638".freeze
    EXCEL_BASE_URL = "https://dumrt.ru/netcat_files/multifile/2649".freeze
    PAGE_URL = "https://dumrt.ru/ru/help-info/prayertime/".freeze

    def fetch_csv(source_filename)
      body = download_body("#{BASE_URL}/#{source_filename}")
      body.force_encoding("UTF-8")
    end

    def fetch_cities
      body = download_body(PAGE_URL)
      body.scan(/data-url="\/netcat_files\/391\/638\/([^"]+\.csv)[^"]*">([^<]+)</).map do |filename, name|
        { name: name.strip, source_filename: filename }
      end
    end

    def excel_url_for(year)
      body = download_body(PAGE_URL)
      match = body.match(/href="([^"]*vremena_namazov_RT_#{year}[^"]*\.xlsx)"/i)
      return absolute_url(match[1]) if match

      "#{EXCEL_BASE_URL}/vremena_namazov_RT_#{year}_0.xlsx"
    end

    def download(url)
      path = Rails.root.join("tmp", "dumrt_prayer_times_#{SecureRandom.hex(8)}.xlsx")
      download_to(url, path.to_s)
      path.to_s
    end

    private

    def absolute_url(path)
      return path if path.start_with?("http")

      "https://dumrt.ru#{path}"
    end

    def download_body(url)
      path = Rails.root.join("tmp", "dumrt_download_#{SecureRandom.hex(8)}")
      download_to(url, path.to_s)
      File.read(path.to_s).tap { File.delete(path) }
    end

    def download_to(url, destination)
      stdout, stderr, status = Open3.capture3("curl", "-fsSL", url, "-o", destination)
      return if status.success? && File.exist?(destination) && File.size?(destination)

      raise "DUM RT download failed (#{url}): #{stderr.presence || stdout}"
    end
  end
end
