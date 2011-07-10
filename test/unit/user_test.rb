require 'test_helper'

class UserTest < ActiveSupport::TestCase

  setup do
    @user = Factory :user
  end

  test "filter junks mails" do
    assert Factory.build(:user).valid?
    assert !Factory.build(:user, :email => 'test@test.test').valid?
    assert !Factory.build(:user, :email => nil).valid?
    assert !Factory.build(:user, :email => 'toto@jetable.org').valid?
  end

  test "method missing on vote_for_candidate should return nil if not define" do
    assert_nil @user.vote_for_candidate_1
    assert_nil @user.vote_for_candidate_13456
  end

  test "method missing on vote_for_candidate should return vote for candidate" do
    candidate = Factory :candidate
    vote = Factory :vote, :candidate => candidate, :user => @user, :vote => 2

    @user.reload
    assert_equal vote.vote, @user.send("vote_for_candidate_#{candidate.id}")

    candidate = Factory :candidate
    vote = Factory :vote, :candidate => candidate, :user => @user, :vote => -1

    @user.reload
    assert_equal vote.vote, @user.send("vote_for_candidate_#{candidate.id}")

   end

end
