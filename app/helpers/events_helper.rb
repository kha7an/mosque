module EventsHelper
  def event_excerpt(event, length: 160)
    return if event.description.blank?

    truncate(event.description, length: length, separator: " ")
  end
end
