class VideosController < ApplicationController
  def index
    @videos = Video.published
    @video_categories = Video::CATEGORIES
  end
end
