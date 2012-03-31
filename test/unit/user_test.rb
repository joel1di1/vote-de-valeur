require 'test_helper' unless eval "begin; Spork.using_spork?; rescue; false; end"

class UserTest < ActiveSupport::TestCase

  setup do
    @u = User.new
  end

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

  test 'parse_vote_value' do

    assert_parse_equal 1, '1'
    assert_parse_equal 1, '+1'
    assert_parse_equal 2, '2'
    assert_parse_equal 2, '+2'
    assert_parse_equal -1, '-1'
    assert_parse_equal -2, '-2'

    assert_parse_nil '22po'
    assert_parse_nil '22po432'
    assert_parse_nil ''
    assert_parse_nil '   '
    assert_parse_nil nil
  end

  def assert_parse_equal expected, value
    assert_equal expected, @u.parse_vote_value(value)
  end

  def assert_parse_nil value
    assert_nil @u.parse_vote_value(value)
  end

end
