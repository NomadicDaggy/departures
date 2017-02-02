class CreateCarriers < ActiveRecord::Migration[5.0]
  def change
    create_table :carriers do |t|
      t.string :code, limit: 7
      t.string :description

      t.timestamps
    end
    add_index :carriers, :code, unique: true
  end
end
