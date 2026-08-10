module DatesHelper
  def l_hijri(date = Time.zone.today)
    gregorian = date.to_date
    hijri = Hijri::Date.new(*Hijri::Converter.greo_to_hijri(gregorian))
    month = t("hijri.month_names")[hijri.month]

    t("hijri.formats.long", day: hijri.day, month:, year: hijri.year)
  end

  # Учебный год медресе: сентябрь - май. Формат «2026/27».
  def academic_year_label(date = Time.zone.today)
    start_year = academic_year_start_year(date)
    academic_year_label_for(start_year)
  end

  # Год начала учебного года для записи: с июня - на следующий сентябрь.
  def enrollment_academic_year_label(date = Time.zone.today)
    start_year = enrollment_academic_year_start(date)
    academic_year_label_for(start_year)
  end

  private

  def academic_year_start_year(date)
    date.month >= 9 ? date.year : date.year - 1
  end

  def enrollment_academic_year_start(date)
    if date.month >= 6
      date.year
    else
      date.year - 1
    end
  end

  def academic_year_label_for(start_year)
    "#{start_year}/#{(start_year + 1) % 100}"
  end
end
