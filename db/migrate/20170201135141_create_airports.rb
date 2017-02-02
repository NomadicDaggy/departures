class CreateAirports < ActiveRecord::Migration[5.0]
  def change
    create_table :airports do |t|
      t.string :iata, limit: 4
      t.string :airport
      t.string :city
      t.string :state
      t.string :country
      t.float :lat
      t.float :long

      t.timestamps
    end
    add_index :airports, :iata, unique: true
  end
end
