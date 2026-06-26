class Avo::Resources::GalleryPhoto < Avo::BaseResource
  def fields
    field :id, as: :id
    field :gallery_group, as: :belongs_to, required: true
    field :image, as: :file, is_image: true, required: true
    field :position, as: :number, help: "Порядок фото внутри группы — чем меньше, тем раньше в карусели. Если оставить пустым, фото добавится в конец"
  end
end
