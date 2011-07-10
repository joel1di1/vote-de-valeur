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

  def assert_parse_equal expected, value
    assert_equal expected, @c.parse_vote_value(value)
  end

  def assert_parse_nil value
    assert_nil @c.parse_vote_value(value)
  end

end
