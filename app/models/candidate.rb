class Candidate < ActiveRecord::Base
  has_many :votes
  has_many :classic_votes


  def votes_total
    total = 0
    votes.each{|v|
      total = total + v.vote unless v.vote.nil?
    }
    total
  end

  def classic_votes_total
    classic_votes.count
  end
end
