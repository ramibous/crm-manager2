class AddUnsubscribedToMessages < ActiveRecord::Migration[7.1]
  def change
    add_column :messages, :unsubscribed, :boolean
  end
end
