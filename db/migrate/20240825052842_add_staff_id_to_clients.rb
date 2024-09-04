class AddStaffIdToClients < ActiveRecord::Migration[7.1]
  def change
    add_column :clients, :staff_id, :integer
  end
end
