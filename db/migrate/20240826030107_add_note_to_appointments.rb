class AddNoteToAppointments < ActiveRecord::Migration[7.1]
  def change
    add_column :appointments, :note, :text
  end
end
