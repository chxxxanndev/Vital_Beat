class FixUserActiveColumn < ActiveRecord::Migration[8.1]
  def change
    # 1. Safely remove junk columns only if they still exist
    remove_column :users, :default, :string if column_exists?(:users, :default)
    remove_column :users, :true, :string if column_exists?(:users, :true)

    # 2. Update existing users so they aren't NULL (Required for the next step)
    execute("UPDATE users SET active = 1 WHERE active IS NULL")

    # 3. Apply the strict boolean rule
    change_column :users, :active, :boolean, default: true, null: false
  end
end