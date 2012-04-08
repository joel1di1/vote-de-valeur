require 'test_helper' unless eval "begin; Spork.using_spork?; rescue; false; end"

class UserSendOpeningMailsTest < ActiveSupport::TestCase

  test 'should mark users as mailed' do
    # setup
    user = FactoryGirl.create :user
    assert_equal 0, user.reload.mailed_status

    # action 
    User.send_opening_mails

    # assert
    assert_equal 1, user.reload.mailed_status
  end

  test 'should send email to users' do
    # setup
    user = FactoryGirl.create :user

    # expectation 
    mock_mail = mock
    mock_mail.expects :deliver
    UserMailer.expects(:election_open_mail).with(user).returns(mock_mail)

    # action 
    User.send_opening_mails
  end

  test 'should send skip previously mailed users' do
    # setup
    user = FactoryGirl.create :user, :mailed_status => 1

    # expectation 
    UserMailer.expects(:election_open_mail).with(user).never

    # action 
    User.send_opening_mails
  end


end