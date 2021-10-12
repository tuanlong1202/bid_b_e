class ChangeTenderDecimalToDefault < ActiveRecord::Migration[6.1]
  def change
    change_column_default(:tenders, :price, from: nil, to: 0.0)
  end
end
