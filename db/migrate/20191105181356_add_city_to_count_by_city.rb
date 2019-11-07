class AddCityToCountByCity < ActiveRecord::Migration[6.0]
  def change
    add_reference :count_by_cities, :city, null: false, foreign_key: true
  end
end
