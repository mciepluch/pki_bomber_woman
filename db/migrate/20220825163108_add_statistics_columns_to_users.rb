class AddStatisticsColumnsToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :kills, :integer, default: 0, null: false
    add_column :users, :suicides, :integer, default: 0, null: false
    add_column :users, :wins, :integer, default: 0, null: false
    add_column :users, :games_played, :integer, default: 0, null: false
  end
end
