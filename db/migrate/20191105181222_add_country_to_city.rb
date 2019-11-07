class AddCountryToCity < ActiveRecord::Migration[6.0]
  def change
    add_reference :cities, :country, null: false, foreign_key: true
  end
end
