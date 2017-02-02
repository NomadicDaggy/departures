class CreateDepartureMatrices < ActiveRecord::Migration[5.0]
  def change
    create_table :departure_matrices do |t|

      t.timestamps
    end
  end
end
