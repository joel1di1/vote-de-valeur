class CreateVoteSecondTours < ActiveRecord::Migration
  def change
    create_table :vote_second_tours do |t|
      t.string  :key
      t.integer :first_candidate_id
      t.integer :second_candidate_id
      t.integer :chosen_candidate_id
      t.string  :original_fight_id

      t.timestamps
    end
  end
end
