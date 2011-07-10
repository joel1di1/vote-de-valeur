require 'test_helper'

class UserTest < ActiveSupport::TestCase

  test 'user create should call send confirmation on user mailer' do
    user = Factory.build :user
    mail = mock
    mail.expects :deliver
    UserMailer.expects(:send_confirmation).with(user).returns(mail)

    user.save
  end

  test 'user create should send confirmation mail' do
    user = Factory.build :user

    assert_difference 'ActionMailer::Base.deliveries.count' do
      user.save
    end
  end


  test "filter junks mails" do
    assert Factory.build(:user).valid?
    assert !Factory.build(:user, :email => 'test@test.test').valid?
    assert !Factory.build(:user, :email => nil).valid?
    assert !Factory.build(:user, :email => 'toto@jetable.org').valid?
  end

  test "method missing on vote_for_candidate should return nil if not define" do
    user = Factory :user
    assert_nil user.vote_for_candidate_1
    assert_nil user.vote_for_candidate_13456
  end

  test "method missing on vote_for_candidate should return vote for candidate" do
    user = Factory :user
    candidate = Factory :candidate
    vote = Factory :vote, :candidate => candidate, :user => user, :vote => 2

    user.reload
    assert_equal vote.vote, user.send("vote_for_candidate_#{candidate.id}")

    candidate = Factory :candidate
    vote = Factory :vote, :candidate => candidate, :user => user, :vote => -1

    user.reload
    assert_equal vote.vote, user.send("vote_for_candidate_#{candidate.id}")

   end

end
