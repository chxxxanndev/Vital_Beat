class AddActiveToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :active, :boolean
    add_column :users, :default, :string
    add_column :users, :true, :string
  end
end
