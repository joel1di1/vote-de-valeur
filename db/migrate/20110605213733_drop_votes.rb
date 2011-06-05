class DropVotes < ActiveRecord::Migration
  def self.up
    drop_table :votes
  end
end
