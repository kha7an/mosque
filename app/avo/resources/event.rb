class Avo::Resources::Event < Avo::BaseResource
  def fields
    field :id, as: :id
    field :title, as: :text, required: true
    field :category, as: :select, options: -> {
      Event::CATEGORIES.index_with { |key| I18n.t("events.categories.#{key}") }.invert
    }
    field :description, as: :textarea
    field :cover, as: :file, is_image: true, help: -> { I18n.t("events.avo.cover_hint") }
    field :starts_at, as: :date_time, required: true, sortable: true
    field :location, as: :text, help: -> { I18n.t("events.avo.location_hint") }
    field :featured, as: :boolean, help: -> { I18n.t("events.avo.featured_hint") }
    field :link, as: :text, help: -> { I18n.t("events.avo.link_hint") }
    field :created_at, as: :date_time, readonly: true, hide_on: [ :new, :edit ]
  end
end
