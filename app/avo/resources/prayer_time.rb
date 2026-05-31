class Avo::Resources::PrayerTime < Avo::BaseResource
  def fields
    field :id, as: :id
    field :city, as: :belongs_to
    field :date, as: :date, sortable: true
    field :end_suhur, as: :time
    field :fajr, as: :time
    field :sunrise, as: :time
    field :zenith, as: :time
    field :zuhr, as: :time
    field :asr, as: :time
    field :maghrib, as: :time
    field :isha, as: :time
    field :jumua, as: :time
  end
end
