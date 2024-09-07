class RemoveNotNullFromManagerIdInClients < ActiveRecord::Migration[7.1]
  def change
    change_column_null :clients, :manager_id, true
  end
end
