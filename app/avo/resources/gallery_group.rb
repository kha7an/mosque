class Avo::Resources::GalleryGroup < Avo::BaseResource
  def fields
    field :id, as: :id
    field :title, as: :text, required: true
    field :slug, as: :text, required: true, help: "Используется как якорь ссылки на странице галереи, латиницей: nikah, isem-kushu"
    field :description, as: :textarea
    field :position, as: :number, help: "Порядок групп на странице - чем меньше, тем выше. Если оставить пустым, группа добавится в конец"
    field :gallery_photos, as: :has_many
  end

  def actions
    action Avo::Actions::UploadGalleryPhotos
  end
end
