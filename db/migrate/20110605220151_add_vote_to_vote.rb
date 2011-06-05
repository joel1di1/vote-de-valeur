class AddVoteToVote < ActiveRecord::Migration
  def self.up
    add_column :votes, :vote, :integer
  end

  def self.down
    remove_column :votes, :vote
  end
end
