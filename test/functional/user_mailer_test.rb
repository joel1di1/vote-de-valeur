require 'test_helper'

class UserMailerTest < ActionMailer::TestCase

  test "when election started, send confirmation mail should give link to vote" do
    # setup
    DateHelper.set_election_time 1.day.ago, 1.day.from_now
    user = Factory.build :user

    # action
    mail = UserMailer.send_confirmation(user).deliver

    # assert
    assert_equal 1, mail.to.count
    assert mail.to.include?(user.email)

    assert_match /http:\/\/.*\/users\/access\/#{user.access_token}/, mail.body
  end

  test "when election has not started, send confirmation mail should say we call you later" do

    # setup
    DateHelper.set_election_time 1.day.from_now, 2.days.from_now
    user = Factory.build :user

    # action
    mail = UserMailer.send_confirmation(user).deliver

    # assert
    assert_equal 1, mail.to.count
    assert mail.to.include?(user.email)

    assert ! mail.body.to_s.match(/#{user.access_token}/)
    assert_match /Un mail vous sera envoy. . l'ouverture du bureau de vote/, mail.body
  end

  test 'election_open_mail ' do
    # setup
    user = Factory :user

    # action
    mail = UserMailer.election_open_mail(user).deliver

    # assert
    assert_equal 1, mail.to.count
    assert mail.to.include?(user.email)

    assert_match /http:\/\/.*\/users\/access\/#{user.access_token}/, mail.body
  end


end
