class ChangeBidDecimalToDefault < ActiveRecord::Migration[6.1]
  def change
    change_column_default(:bids, :price, from: nil, to: 0.0)
    change_column_default(:bids, :last_price, from: nil, to: 0.0)
  end
end
