class VideosController < ApplicationController
  def index
    @videos = Video.published.sermons
    @video_categories = Video::SERMON_CATEGORIES
  end
end
