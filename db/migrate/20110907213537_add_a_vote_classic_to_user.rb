class AddAVoteClassicToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :a_vote_classic, :boolean
  end

  def self.down
    remove_column :users, :a_vote_classic
  end
end
