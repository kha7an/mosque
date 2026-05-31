module Hadiths
  class DailyPresenter
    Hadith = Data.define(:arabic, :translation, :narrator, :book_label)

    SOURCE_PATH = Rails.root.join("public/hadises/hadith_150_bukhari_muslim_tirmidhi_ru.json")

    COLLECTIONS = {
      "Sahih al-Bukhari" => "Сахих аль-Бухари",
      "Sahih Muslim" => "Сахих Муслим",
      "Jami` at-Tirmidhi" => "Джами ат-Тирмиди"
    }.freeze

    AUTHENTICITY = {
      "sahih" => "сахих",
      "hasan" => "хасан"
    }.freeze

    def self.for(date: Time.zone.today)
      new(date:).call
    end

    def initialize(date:)
      @date = date.to_date
    end

    def call
      hadith = pick_hadith
      return nil unless hadith

      Hadith.new(
        arabic: hadith.fetch("matn_arabic"),
        translation: hadith.fetch("meaning_ru"),
        narrator: hadith.fetch("narrator"),
        book_label: book_label_for(hadith)
      )
    end

    private

    def pick_hadith
      hadiths = load_hadiths
      return nil if hadiths.empty?

      index = Zlib.crc32(@date.to_s) % hadiths.size
      hadiths[index]
    end

    def load_hadiths
      Rails.cache.fetch("hadiths/all", expires_in: 1.day) do
        data = JSON.parse(File.read(SOURCE_PATH))
        data.fetch("hadiths", [])
      rescue Errno::ENOENT, JSON::ParserError
        []
      end
    end

    def book_label_for(hadith)
      collection = COLLECTIONS.fetch(hadith["collection"], hadith["collection"])
      authenticity = AUTHENTICITY.fetch(hadith["authenticity"], hadith["authenticity"])

      "#{collection} · #{authenticity}"
    end
  end
end
