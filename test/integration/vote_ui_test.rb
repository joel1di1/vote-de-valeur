# coding: utf-8
require 'test_helper' unless eval "begin; Spork.using_spork?; rescue; false; end"

class VoteUiTest < ActionDispatch::IntegrationTest

  setup do
    @user = FactoryGirl.create :user
    @candidate_1 = FactoryGirl.create :candidate
    @candidate_2 = FactoryGirl.create :candidate

    DateHelper.set_election_time 1.day.ago, 1.day.from_now
  end

  def go_to_vote
    ui_sign_in @user
    click_link 'Continuer'
  end

  def go_to_classic
    click_on 'next_to_classic'
  end

  def select_vote_for candidate, vote
    choose "user_vote_for_candidate_#{candidate.id}_#{vote}"
  end

  def submit_vote
    click_on 'submit_votes'
  end

  def select_classic_vote candidate
    choose "user_classic_vote_#{candidate.id}"
  end

  test "user should see explanation after signed in" do
    ui_sign_in @user

    assert page.has_content? "bureau de vote virtuel"
  end

  test "vote form should display candidates form" do
    go_to_vote

    assert page.has_content? @candidate_1.name
    assert page.has_content? @candidate_2.name

    # vote de valeur
    assert page.has_field? "user[vote_for_candidate_#{@candidate_1.id}]"
    assert page.has_field? "user[vote_for_candidate_#{@candidate_2.id}]"

    # vote classique
    assert page.has_field? "user[classic_vote]"
    assert page.has_field? "user_classic_vote_#{@candidate_1.id}"
    assert page.has_field? "user_classic_vote_#{@candidate_2.id}"
  end

  test "when user vote he should be marked" do
    # setup
    assert !@user.a_vote?
    assert !@user.a_vote_classic?

    # action
    go_to_vote

    select_vote_for @candidate_1, 1
    select_vote_for @candidate_2, -2

    go_to_classic

    select_classic_vote @candidate_2
    submit_vote
    
    # assert
    @user.reload
    assert @user.a_vote?
    @user.reload
    assert @user.a_vote_classic?
  end

  test "user should create his vote" do
    go_to_vote

    assert_difference ["Vote.find_all_by_candidate_id(#{@candidate_1.id}).count",
                       "Vote.find_all_by_candidate_id(#{@candidate_2.id}).count",
                       "ClassicVote.count"] do
      select_vote_for @candidate_1, 1
      select_vote_for @candidate_2, -2
      go_to_classic

      select_classic_vote @candidate_2
      submit_vote
    end
  end

  test "user should be able to vote only once" do
    # setup
    go_to_vote
    select_vote_for @candidate_1, 1
    go_to_classic
    submit_vote

    # action
    go_to_vote

    # assert
    assert_equal second_tour_votes_path, page.current_path
  end

end
