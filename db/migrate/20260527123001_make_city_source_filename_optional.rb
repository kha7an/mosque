class MakeCitySourceFilenameOptional < ActiveRecord::Migration[8.0]
  def change
    change_column_null :cities, :source_filename, true
  end
end
