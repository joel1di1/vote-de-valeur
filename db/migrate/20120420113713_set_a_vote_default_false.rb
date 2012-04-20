class SetAVoteDefaultFalse < ActiveRecord::Migration
  def up
    change_column :users, :a_vote, :boolean, :default => false
    User.update_all("a_vote = FALSE", "a_vote IS NULL" )
  end

  def down
    change_column :users, :a_vote, :boolean
  end
end
