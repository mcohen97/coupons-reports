class AddCountryToCountByCountry < ActiveRecord::Migration[6.0]
  def change
    add_reference :count_by_countries, :country, null: false, foreign_key: true
  end
end
