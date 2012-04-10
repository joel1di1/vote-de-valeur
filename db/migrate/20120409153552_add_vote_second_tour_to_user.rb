class AddVoteSecondTourToUser < ActiveRecord::Migration
  def change
    add_column :users, :a_vote_second_tour, :boolean, :default => false
  end
end
