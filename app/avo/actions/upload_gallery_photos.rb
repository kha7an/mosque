class Avo::Actions::UploadGalleryPhotos < Avo::BaseAction
  self.name = "Загрузить несколько фото"
  self.message = "Фото добавятся в конец списка выбранной группы"

  def fields
    field :images, as: :files, name: "Фотографии", is_image: true
  end

  def handle(query:, fields:, **args)
    uploads = Array(fields[:images]).reject(&:blank?)

    if uploads.empty?
      error "Выберите хотя бы одну фотографию"
      return
    end

    query.each do |group|
      uploads.each do |upload|
        group.gallery_photos.create!.image.attach(upload)
      end
    end

    succeed "Загружено #{uploads.size} фото"
  end
end
