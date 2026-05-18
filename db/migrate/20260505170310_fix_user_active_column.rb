class FixUserActiveColumn < ActiveRecord::Migration[8.1]
  def change
    remove_column :users, :default, :string if column_exists?(:users, :default)
    remove_column :users, :true, :string if column_exists?(:users, :true)

    execute("UPDATE users SET active = 1 WHERE active IS NULL")

    change_column :users, :active, :boolean, default: true, null: false
  end
end