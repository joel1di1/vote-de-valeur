class AddKeyToVote < ActiveRecord::Migration
  def change
    add_column :votes, :key, :string
    add_column :classic_votes, :key, :string

    add_index :votes, :key, :unique => false
    add_index :classic_votes, :key, :unique => true
  end
end
