class Avo::Resources::City < Avo::BaseResource
  def fields
    field :id, as: :id
    field :name, as: :text, required: true
    field :slug, as: :text, required: true
    field :source_filename, as: :text
    field :default, as: :boolean
    field :prayer_times, as: :has_many
  end
end
