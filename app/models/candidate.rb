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

  def self.get_versus
    candidates = Candidate.where(:favorite => true)

    res = []
    candidates.combination(2) do |t|
      t.shuffle!
      res << Fight.new(t[0], t[1])
    end
    res
  end
end

class Fight

  def initialize(first, second)
    @candidates = []
    @candidates << first
    @candidates << second
  end

  def candidates
    @candidates.clone
  end

  def id
    ids = @candidates.collect(&:id)
    "f_#{ids.first}_#{ids.second}"
  end

end