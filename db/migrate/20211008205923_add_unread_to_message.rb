class AddUnreadToMessage < ActiveRecord::Migration[6.1]
  def change
    add_column :messages, :unread, :boolean, default: true
  end
end
