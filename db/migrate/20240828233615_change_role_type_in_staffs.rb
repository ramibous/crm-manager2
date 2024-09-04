class ChangeRoleTypeInStaffs < ActiveRecord::Migration[7.1]
  def up
    # Changing the type of the role column from string to integer
    execute <<-SQL
      ALTER TABLE staffs
      ALTER COLUMN role TYPE integer USING role::integer;
    SQL

    # Now, set the default and not null constraints separately
    change_column_default :staffs, :role, from: nil, to: 0
    change_column_null :staffs, :role, false
  end

  def down
    # Reverse the column type change if needed
    change_column :staffs, :role, :string
  end
end
