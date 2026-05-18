class AddArchivedToHeartRateLogs < ActiveRecord::Migration[8.1]
  def change
    add_column :heart_rate_logs, :archived, :boolean
    add_column :heart_rate_logs, :default, :string
    add_column :heart_rate_logs, :false, :string
  end
end
