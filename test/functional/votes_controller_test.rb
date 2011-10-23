require 'test_helper'

class VotesControllerTest < ActionController::TestCase

  test 'vote is not possible when election is not running' do
    DateHelper.set_election_time 1.day.from_now, 2.days.from_now

    sign_in Factory :user
    post :update

    assert_redirected_to root_path
  end

  test 'user can vote only once' do
    # setup
    DateHelper.set_election_time 1.day.ago, 2.days.from_now
    sign_in Factory :user
    candidate = Factory :candidate

    # action
    post :update, :user => {"vote_for_candidate_#{candidate.id}".to_sym => "2"}
    # assert
    assert_redirected_to votes_classic_path
    candidate.reload
    assert_equal 2, candidate.votes_total

    # action
    post :update, :user => {"vote_for_candidate_#{candidate.id}".to_sym => "-1"}
    # assert
    assert_redirected_to root_path
    candidate.reload
    assert_equal 2, candidate.votes_total
  end


  test 'user can vote classic only once' do
    # setup
    DateHelper.set_election_time 1.day.ago, 2.days.from_now
    sign_in Factory :user
    candidate = Factory :candidate
    candidate_2 = Factory :candidate
    assert_equal 0, candidate.classic_votes_total
    assert_equal 0, candidate_2.classic_votes_total

    # action
    post :update_classic, :user => {:classic_vote => candidate.id}
    # assert
    #assert_redirected_to votes_classic_path
    candidate.reload
    assert_equal 1, candidate.classic_votes_total
    candidate_2.reload
    assert_equal 0, candidate_2.classic_votes_total

    # action
    post :update_classic, :user => {:classic_vote => candidate_2.id}
    # assert
    assert_redirected_to root_path
    candidate.reload
    assert_equal 1, candidate.classic_votes_total
    candidate_2.reload
    assert_equal 0, candidate_2.classic_votes_total
  end

  test 'accessing votes is not possible when election is not running' do
    DateHelper.set_election_time 1.day.from_now, 2.days.from_now

    sign_in Factory :user
    get :index

    assert_redirected_to root_path
  end

  test 'user can access vote only if not marked in session' do
    DateHelper.set_election_time 1.day.ago, 1.day.from_now
    user = Factory :user
    sign_in user

    get :index
    assert_redirected_to root_path

    get :index, nil, {VotesController::TOKEN_VALIDATED_KEY => '1'}
    assert_response :success
  end

end
