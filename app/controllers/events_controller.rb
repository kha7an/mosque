class EventsController < ApplicationController
  def index
    @events = Event.listed
  end

  def show
    @event = Event.find(params[:id])
  end
end
