require 'test_helper'

class VotesControllerTest < ActionController::TestCase

  setup do
    @c = VotesController.new
  end

  test 'Vote is not possible when election is not running' do
    DateHelper.set_election_time 1.day.from_now, 2.days.from_now

    sign_in Factory :user
    post :update

    assert_redirected_to root_path
  end

  test 'accessing votes is not possible when election is not running' do
    DateHelper.set_election_time 1.day.from_now, 2.days.from_now

    sign_in Factory :user
    get :index

    assert_redirected_to root_path
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

  test 'user can access vote only if not marked in session' do
    DateHelper.set_election_time 1.day.ago, 1.day.from_now
    user = Factory :user
    sign_in user

    get :index
    assert_redirected_to root_path

    get :index, nil, session.merge!(VotesController::TOKEN_VALIDATED_KEY => '1')
    assert_response :success
  end

  def assert_parse_equal expected, value
    assert_equal expected, @c.parse_vote_value(value)
  end

  def assert_parse_nil value
    assert_nil @c.parse_vote_value(value)
  end

end
