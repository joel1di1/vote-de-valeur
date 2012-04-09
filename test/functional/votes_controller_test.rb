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
    user = FactoryGirl.create :user
    sign_in user
    candidate = FactoryGirl.create :candidate

    # action
    assert_difference "candidate.reload.votes_total", 2 do
      put :create, :user => {"vote_for_candidate_#{candidate.id}".to_sym => "2"}
    end

    # assert
    assert_redirected_to second_tour_votes_path

    # action
    assert_no_difference "candidate.reload.votes_total" do
      put :create, :user => {"vote_for_candidate_#{candidate.id}".to_sym => "-1"}
    end
    # assert
    assert_redirected_to root_path
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

  test 'second_tour should display secondtour form' do
    DateHelper.set_election_time 1.day.ago, 1.day.from_now
    user = FactoryGirl.create :user
    sign_in user

    get :second_tour

    assert_response :success
    assert_not_nil assigns[:fights]
  end

  test 'vote for second tour' do
    DateHelper.set_election_time 1.day.ago, 1.day.from_now
    user = FactoryGirl.create :user
    sign_in user

    candidate_1 = FactoryGirl.create :candidate, :favorite => true
    candidate_2 = FactoryGirl.create :candidate, :favorite => true

    fight = Fight.new(candidate_1, candidate_2)
    assert_difference 'VoteSecondTour.count' do
      post :vote_second_tour, {fight.id => candidate_1.id}
    end
    
    assert user.reload.a_vote_second_tour?
    vst = VoteSecondTour.last
    assert_equal fight.id, vst.original_fight_id
    assert_equal candidate_1, vst.chosen_candidate
    assert_equal candidate_1, vst.first_candidate
    assert_equal candidate_2, vst.second_candidate
  end

  test 'vote for second tour with several response' do
    DateHelper.set_election_time 1.day.ago, 1.day.from_now
    user = FactoryGirl.create :user
    sign_in user

    uniq_key = User.generate_vote_key
    session[:uniq_key] = uniq_key

    candidate_1 = FactoryGirl.create :candidate, :favorite => true
    candidate_2 = FactoryGirl.create :candidate, :favorite => true
    candidate_3 = FactoryGirl.create :candidate, :favorite => true

    fight_1 = Fight.new(candidate_1, candidate_2)
    fight_2 = Fight.new(candidate_1, candidate_3)
    fight_3 = Fight.new(candidate_3, candidate_2)
    assert_difference 'VoteSecondTour.count', 3 do
      post :vote_second_tour, {fight_1.id => candidate_1.id, fight_2.id => candidate_3.id, fight_3.id => candidate_3.id}
    end
    
    assert_fight fight_1.id, candidate_1, candidate_2, candidate_1, uniq_key
    assert_fight fight_2.id, candidate_1, candidate_3, candidate_3, uniq_key
    assert_fight fight_3.id, candidate_3, candidate_2, candidate_3, uniq_key
  end

  def assert_fight fight_id, c1, c2, chosen_candidate, uniq_key
    vst = VoteSecondTour.find_by_original_fight_id fight_id
    assert_equal c1, vst.first_candidate
    assert_equal c2, vst.second_candidate
    assert_equal chosen_candidate, vst.chosen_candidate
    assert_equal uniq_key, vst.key
  end

end
