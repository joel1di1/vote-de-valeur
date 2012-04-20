class SetAVoteDefaultFalse < ActiveRecord::Migration
  def up
    change_column :users, :a_vote, :boolean, :default => false
  end

  def down
    change_column :users, :a_vote, :boolean
  end
end
