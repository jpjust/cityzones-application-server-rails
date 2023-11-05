class CreateCountries < ActiveRecord::Migration[7.0]

  require 'csv'

  def change
    create_table :countries do |t|
      t.string :name, :null => false
      t.float :lat, :null => false
      t.float :lon, :null => false

      t.timestamps
    end

    countries_data = CSV.read('countries.csv')
    countries_data.each do |row|
      Country.create!({
        name: row[3],
        lat: row[1],
        lon: row[2]
      })
    end
  end

end
