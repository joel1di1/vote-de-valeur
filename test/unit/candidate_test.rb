require 'test_helper'

class CandidateTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "addition" do
    candidate = Factory :candidate
    user = Factory :user
    vote = Factory :vote, :user => user, :candidate => candidate, :vote => nil

    candidate.reload

    assert_equal 0, candidate.votes_total

  end
end
