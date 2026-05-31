year = Time.zone.today.year
result = PrayerTimes::YearlyImportService.call(year:)

city = City.find_by!(slug: "kazan")
city.update!(default: true)

puts "Year #{result.year}: #{result.cities_count} cities, #{result.imported} new, #{result.updated} updated"

if Event.none?
  base = Time.zone.today
  Event.create!(
    [
      {
        title: "Ид аль-Адха в Казани",
        description: "Праздничный гает-намаз в 6:00 в мечети и в 9:00 в парке. Семейная программа до 18:00.",
        starts_at: base.change(hour: 6),
        location: "мечеть и парк",
        category: "special",
        featured: true
      },
      {
        title: "Җомга: «Уроки Хаджа»",
        description: "Пятничная проповедь имама о духовных смыслах паломничества и наследии Ибрахима ﷺ.",
        starts_at: (base + 2.days).change(hour: 13),
        location: "большой зал",
        category: "khutba"
      },
      {
        title: "Встреча Yəshlek Hub",
        description: "Открытая встреча для молодёжи 16–25 лет: общение, чай и обсуждение современных вопросов.",
        starts_at: (base + 5.days).change(hour: 19),
        location: "конференц-зал",
        category: "youth"
      },
      {
        title: "День открытых дверей медресе",
        description: "Знакомство с программами медресе «Шамиль», встреча с преподавателями и запись на курсы.",
        starts_at: (base + 8.days).change(hour: 11),
        location: "медресе",
        category: "education"
      }
    ]
  )
  puts "Events: #{Event.count} sample records"
end
