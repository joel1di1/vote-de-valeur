require 'test_helper' unless eval "begin; Spork.using_spork?; rescue; false; end"

class VotesControllerTest < ActionController::TestCase

  test 'vote is not possible when election is not running' do
    DateHelper.set_election_time 1.day.from_now, 2.days.from_now

    sign_in FactoryGirl.create :user
    put :create

    assert_redirected_to root_path
  end

  test 'user can vote only once' do
    # setup
    DateHelper.set_election_time 1.day.ago, 2.days.from_now
    sign_in FactoryGirl.create :user
    candidate = FactoryGirl.create :candidate

    # action
    put :create, :user => {"vote_for_candidate_#{candidate.id}".to_sym => "2"}

    # assert
    assert_redirected_to thanks_path
    candidate.reload
    assert_equal 2, candidate.votes_total

    # action
    put :create, :user => {"vote_for_candidate_#{candidate.id}".to_sym => "-1"}
    # assert
    assert_redirected_to root_path
    candidate.reload
    assert_equal 2, candidate.votes_total
  end

  test 'accessing votes is not possible when election is not running' do
    DateHelper.set_election_time 1.day.from_now, 2.days.from_now

    sign_in FactoryGirl.create :user
    get :index

    assert_redirected_to root_path
  end

  test 'user can access vote only if not marked in session' do
    DateHelper.set_election_time 1.day.ago, 1.day.from_now
    user = FactoryGirl.create :user
    sign_in user

    get :index
    assert_redirected_to root_path

    get :index, nil, {VotesController::TOKEN_VALIDATED_KEY => '1'}
    assert_response :success
  end

end
