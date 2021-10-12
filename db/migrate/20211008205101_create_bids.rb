class CreateBids < ActiveRecord::Migration[6.1]
  def change
    create_table :bids do |t|
      t.string :subject
      t.string :image
      t.decimal :price, precision: 10, scale: 2
      t.text :description
      t.decimal :last_price, precision: 10, scale: 2
      t.integer :user_id

      t.timestamps
    end
  end
end
