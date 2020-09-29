class CreateEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :events do |t|
      t.integer :producer_id
      t.integer :location_id
      t.string :name
      t.datetime :start_date
      t.datetime :end_date
      t.decimal :price
      t.string :image_url
      t.integer :maximum_capacity
      t.integer :minimum_age

      t.timestamps
    end
  end
end
