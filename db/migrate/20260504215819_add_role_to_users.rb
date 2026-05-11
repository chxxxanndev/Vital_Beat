class AddRoleToUsers < ActiveRecord::Migration[8.1]
  def change
    # Add , default: 'patient' at the end of the line
    add_column :users, :role, :string, default: 'patient'
  end
end