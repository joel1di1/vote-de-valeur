# coding: utf-8
require 'integration_test_helper'

class VoteUiTest < ActionDispatch::IntegrationTest

  setup do
    @user = Factory :user
    @candidate_1 = Factory :candidate
    @candidate_2 = Factory :candidate

    ui_sign_in @user

    DateHelper.set_election_time 1.day.ago, 1.day.from_now
  end

  def go_to_vote
    ui_sign_in @user
  end

  def select_vote_for candidate, vote
    choose "user_vote_for_candidate_#{candidate.id}_#{vote}"
  end

  def submit_vote
    click_on 'Valider'
  end

  def select_classic_vote candidate
    choose "user_classic_vote_#{candidate.id}"
  end


  test "vote form should display candidates form" do
    go_to_vote

    assert page.has_content? 'Votre vote'
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


  test "user should create his vote" do
    go_to_vote

    assert_difference ["Vote.find_all_by_candidate_id(#{@candidate_1.id}).count",
                       "Vote.find_all_by_candidate_id(#{@candidate_2.id}).count",
                       "ClassicVote.count"] do
      assert_difference ['Vote.count', "User.find(#{@user.id}).votes.count"], 2 do
        select_vote_for @candidate_1, 1
        select_vote_for @candidate_2, -2

        select_classic_vote @candidate_2
        submit_vote
      end
    end

    @user.reload
    assert_equal +1, @user.vote_for_candidate(@candidate_1.id)
    assert_equal -2, @user.vote_for_candidate(@candidate_2.id)

    assert_not_nil @user.classic_vote
    assert_equal @candidate_2, @user.classic_vote.candidate

  end


  test "user with existing votes should update his votes" do
    go_to_vote

    select_vote_for @candidate_1, 1
    select_vote_for @candidate_2, -2

    select_classic_vote @candidate_2

    submit_vote

    assert_no_difference ["Vote.find_all_by_candidate_id(#{@candidate_1.id}).count",
                          "Vote.find_all_by_candidate_id(#{@candidate_2.id}).count",
                          'Vote.count',
                          '@user.votes.count',
                          'ClassicVote.count'] do
      select_vote_for @candidate_1, 0
      select_vote_for @candidate_2, 2

      select_classic_vote @candidate_1

      submit_vote
    end

    @user.reload
    assert_equal 0, @user.vote_for_candidate(@candidate_1.id)
    assert_equal 2, @user.vote_for_candidate(@candidate_2.id)

    assert_equal @candidate_1, @user.classic_vote.candidate
  end

  test "classic vote should be already checked if classic_vote present" do
    go_to_vote
    select_vote_for @candidate_1, 1
    select_vote_for @candidate_2, -2
    select_classic_vote @candidate_2
    submit_vote

    # action
    go_to_vote

    # assert
    assert page.has_selector? "#classic_vote input[checked]"
    assert_equal @candidate_2.id, page.find(:css, '#classic_vote input[checked]').value.to_i
  end

end
