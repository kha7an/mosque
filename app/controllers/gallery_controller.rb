class GalleryController < ApplicationController
  def index
    @groups = GalleryGroup.ordered.includes(gallery_photos: { image_attachment: :blob })
  end
end
