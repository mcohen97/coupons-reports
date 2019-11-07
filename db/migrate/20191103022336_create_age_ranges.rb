class CreateAgeRanges < ActiveRecord::Migration[6.0]
  def change
    create_table :age_ranges do |t|
      t.integer :from
      t.integer :to

      t.timestamps
    end
  end
end
