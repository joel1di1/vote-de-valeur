class RemoveLinkBetweenVoteAndUser < ActiveRecord::Migration
  def self.up
    remove_column :classic_votes, :user_id
    remove_column :votes, :user_id
  end

  def self.down
    change_table :classic_votes do |t|
      t.references :user
    end
    change_table :votes do |t|
      t.references :user
    end
  end
end
