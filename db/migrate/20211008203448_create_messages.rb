class CreateMessages < ActiveRecord::Migration[6.1]
  def change
    create_table :messages do |t|
      t.string :subject
      t.text :memo
      t.integer :sender
      t.integer :receiver

      t.timestamps
    end
  end
end
