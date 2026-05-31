class Avo::Resources::Video < Avo::BaseResource
  def fields
    field :id, as: :id
    field :title, as: :text, required: true
    field :category, as: :select, options: -> {
      Video::CATEGORIES.index_with { |key| I18n.t("videos.categories.#{key}") }.invert
    }
    field :description, as: :textarea
    field :link, as: :text, required: true, help: -> { I18n.t("videos.avo.link_hint") }
    field :created_at, as: :date_time, readonly: true, hide_on: [ :new, :edit ]
  end

  self.grid_view = {
    card: -> do
      {
        cover_url:
          if record.cover_photo.attached?
            main_app.url_for(record.cover_photo.url)
          end,
        title: record.name,
        body: record.truncated_body
      }
    end
  }
end
