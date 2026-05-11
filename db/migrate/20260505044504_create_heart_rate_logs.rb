class CreateHeartRateLogs < ActiveRecord::Migration[8.1]
  def change
    create_table :heart_rate_logs do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :bpm
      t.float :mhr_percentage
      t.string :status
      t.string :zone
      t.datetime :recorded_at
      t.text :notes

      t.timestamps
    end
  end
end
