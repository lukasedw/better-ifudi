class CreateRestaurants < ActiveRecord::Migration[7.0]
  def change
    create_table :restaurants do |t|
      t.string :id_ifudi
      t.string :name
      t.string :action
      t.boolean :available
      t.decimal :user_rating, precision: 19, scale: 2
      t.integer :quantity

      t.timestamps
    end
  end
end
