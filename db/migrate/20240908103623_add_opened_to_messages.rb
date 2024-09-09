class AddOpenedToMessages < ActiveRecord::Migration[7.1]
  def change
    add_column :messages, :opened, :boolean
  end
end
