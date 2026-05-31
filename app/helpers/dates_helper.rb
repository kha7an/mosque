module DatesHelper
  def l_hijri(date = Time.zone.today)
    gregorian = date.to_date
    hijri = Hijri::Date.new(*Hijri::Converter.greo_to_hijri(gregorian))
    month = t("hijri.month_names")[hijri.month]

    t("hijri.formats.long", day: hijri.day, month:, year: hijri.year)
  end
end
