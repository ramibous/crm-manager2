class AddDescriptionToInteractions < ActiveRecord::Migration[7.1]
  def change
    add_column :interactions, :description, :text
  end
end
