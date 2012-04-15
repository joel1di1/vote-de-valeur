class VoteSecondTour < ActiveRecord::Base

  belongs_to :chosen_candidate, :class_name => "Candidate", :foreign_key => "chosen_candidate_id"
  belongs_to :first_candidate, :class_name => "Candidate", :foreign_key => "first_candidate_id"
  belongs_to :second_candidate, :class_name => "Candidate", :foreign_key => "second_candidate_id"

  attr_accessible :chosen_candidate, :first_candidate, :key, :second_candidate, :original_fight_id


  def self.create_with original_fight_id, chosen_candidate_id, key
    m = /f_(\d+)_(\d+)/.match original_fight_id

    candidate_1 = Candidate.find m[1]
    candidate_2 = Candidate.find m[2]
    chosen_one  = chosen_candidate_id.nil? ? nil : Candidate.find(chosen_candidate_id)

    VoteSecondTour.create! :original_fight_id => original_fight_id, 
                          :first_candidate => candidate_1, 
                          :second_candidate => candidate_2,
                          :chosen_candidate => chosen_one,
                          :key => key
  end

  def self.find_with_original_fight_id original_fight_id
    v2t = VoteSecondTour.find_by_original_fight_id original_fight_id
    if v2t.nil?
      m = /f_(\d+)_(\d+)/.match original_fight_id
      v2t = VoteSecondTour.find_by_original_fight_id "f_#{m[2]}_#{m[1]}"
    end
    v2t
  end
end
