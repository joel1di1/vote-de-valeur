require 'test_helper' unless eval "begin; Spork.using_spork?; rescue; false; end"

class CandidateTest < ActiveSupport::TestCase

  test "addition" do
    # setup
    candidate = Factory :candidate
    user = Factory :user

    # action
    Factory :vote, :candidate => candidate, :vote => nil

    # assert
    candidate.reload
    assert_equal 0, candidate.votes_total
  end

  test "classic_addition" do
    # setup
    candidate = Factory :candidate
    user = Factory :user
    assert_equal 0, candidate.classic_votes_total

    # action
    Factory :classic_vote, :candidate => candidate

    # assert
    candidate.reload
    assert_equal 1, candidate.classic_votes_total 
  end

end
