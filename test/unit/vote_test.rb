require 'test_helper' unless eval "begin; Spork.using_spork?; rescue; false; end"

class VoteTest < ActiveSupport::TestCase

  test "vote should have only values between minus 2 and 2" do

    assert vote_valid_with? nil
    assert vote_valid_with? -2
    assert vote_valid_with? -1
    assert vote_valid_with? 0
    assert vote_valid_with? 1
    assert vote_valid_with? 2

    assert !vote_valid_with?(+3)
    assert !vote_valid_with?(-3)

  end

  def vote_valid_with? value
    vote = Factory.build :vote, :vote => value
    vote.valid?
  end


end
