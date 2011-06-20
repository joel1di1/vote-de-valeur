class Candidate < ActiveRecord::Base
  has_many :votes
  def votes_total
    total = 0
    votes.each{|v|
      total = total + v.vote unless v.vote.nil?
    }
    total
  end
end
