class AddEndSessionToBid < ActiveRecord::Migration[6.1]
  def change
    add_column :bids, :end_session, :boolean, default: false
  end
end
