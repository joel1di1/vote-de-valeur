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

end
