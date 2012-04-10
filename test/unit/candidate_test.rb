require 'test_helper' unless eval "begin; Spork.using_spork?; rescue; false; end"

class CandidateTest < ActiveSupport::TestCase

  test "addition" do
    # setup
    candidate = FactoryGirl.create :candidate
    user = FactoryGirl.create :user

    # action
    FactoryGirl.create :vote, :candidate => candidate, :vote => nil

    # assert
    candidate.reload
    assert_equal 0, candidate.votes_total
  end

  test "classic_addition" do
    # setup
    candidate = FactoryGirl.create :candidate
    user = FactoryGirl.create :user
    assert_equal 0, candidate.classic_votes_total

    # action
    FactoryGirl.create :classic_vote, :candidate => candidate

    # assert
    candidate.reload
    assert_equal 1, candidate.classic_votes_total 
  end

  test 'get_versus should returns combination between favorites' do
    candidate_1 = FactoryGirl.create :candidate, :favorite => true
    candidate_2 = FactoryGirl.create :candidate, :favorite => true
    candidate_3 = FactoryGirl.create :candidate, :favorite => false

    tab = Candidate.get_versus
    assert_equal 1, tab.size
    fight = tab.first
    candidates = fight.candidates
    assert [candidate_1, candidate_2].include? candidates.first
    assert [candidate_1, candidate_2].include? candidates.second
    assert candidates.first != candidates.second
  end

  test 'get_versus should returns combination between favorites when more than 2 favorites' do
    candidate_1 = FactoryGirl.create :candidate, :favorite => true
    candidate_2 = FactoryGirl.create :candidate, :favorite => true
    candidate_3 = FactoryGirl.create :candidate, :favorite => false
    candidate_4 = FactoryGirl.create :candidate, :favorite => true

    tab = Candidate.get_versus
    assert_equal 3, tab.size
  end

end
