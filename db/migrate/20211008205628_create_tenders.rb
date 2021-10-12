class CreateTenders < ActiveRecord::Migration[6.1]
  def change
    create_table :tenders do |t|
      t.text :description
      t.decimal :price, precision: 10, scale: 2
      t.integer :bid_id
      t.integer :user_id

      t.timestamps
    end
  end
end
