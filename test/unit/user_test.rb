require 'test_helper' unless eval "begin; Spork.using_spork?; rescue; false; end"

class UserTest < ActiveSupport::TestCase

  setup do
    @u = User.new
  end

  test 'user create should call send confirmation on user mailer' do
    user = FactoryGirl.build :user
    mail = mock
    mail.expects :deliver
    UserMailer.expects(:send_confirmation).with(user).returns(mail)

    user.save
  end

  test 'user create should send confirmation mail' do
    user = FactoryGirl.build :user

    assert_difference 'ActionMailer::Base.deliveries.count' do
      user.save
    end
  end


  test "filter junks mails" do
    assert FactoryGirl.build(:user).valid?
    assert !FactoryGirl.build(:user, :email => 'test@test.test').valid?
    assert !FactoryGirl.build(:user, :email => nil).valid?
    assert !FactoryGirl.build(:user, :email => 'toto@jetable.org').valid?
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

  test 'votes should add new votes' do
    candidate_1 = FactoryGirl.create :candidate
    candidate_2 = FactoryGirl.create :candidate

    assert_difference ["Vote.find_all_by_candidate_id(#{candidate_1.id}).count",
                       "Vote.find_all_by_candidate_id(#{candidate_2.id}).count",
                       "ClassicVote.count"] do
      @u.vote! "vote_for_candidate_#{candidate_2.id}" => '1', 
               "vote_for_candidate_#{candidate_1.id}" => '-1', 
               "classic_vote" => candidate_2.id.to_s
    end
  end

  test 'votes should add new votes with same generated key' do
    candidate_1 = FactoryGirl.create :candidate
    candidate_2 = FactoryGirl.create :candidate

    key = FactoryGirl.generate(:email)
    User.expects(:generate_vote_key).returns(key)

    @u.vote! "vote_for_candidate_#{candidate_2.id}" => '1', 
             "vote_for_candidate_#{candidate_1.id}" => '-1', 
             "classic_vote" => candidate_2.id.to_s

    assert_equal key, Vote.last.key 
    assert_equal key, ClassicVote.last.key 
  end

  def assert_parse_equal expected, value
    assert_equal expected, @u.parse_vote_value(value)
  end

  def assert_parse_nil value
    assert_nil @u.parse_vote_value(value)
  end

end
