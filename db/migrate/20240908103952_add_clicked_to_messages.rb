class AddClickedToMessages < ActiveRecord::Migration[7.1]
  def change
    add_column :messages, :clicked, :boolean
  end
end
