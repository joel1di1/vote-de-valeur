class AddAvoteToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :a_vote, :boolean
  end

  def self.down
    remove_column :users, :a_vote
  end
end
