require 'test_helper'

class CandidateTest < ActiveSupport::TestCase

  test "addition" do
    # setup
    candidate = Factory :candidate
    user = Factory :user

    # action
    Factory :vote, :user => user, :candidate => candidate, :vote => nil

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
    Factory :classic_vote, :user => user, :candidate => candidate

    # assert
    candidate.reload
    assert_equal 1, candidate.classic_votes_total
  end

end
