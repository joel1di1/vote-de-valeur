require 'integration_test_helper'

class VoteUiTestTest < ActionDispatch::IntegrationTest

  setup do
    @user = Factory :user
    @candidate_1 = Factory :candidate
    @candidate_2 = Factory :candidate

    ui_sign_in @user
  end

  test "vote form should display candidates form" do
    click_on 'Votez'

    assert page.has_content? 'Votre vote'
    assert page.has_content? @candidate_1.name
    assert page.has_content? @candidate_2.name

    assert page.has_field? "user[vote_for_candidate_#{@candidate_1.id}]"
    assert page.has_field? "user[vote_for_candidate_#{@candidate_2.id}]"
  end


  test "user should create his vote" do
    click_on 'Votez'

    assert_difference ["Vote.find_all_by_candidate_id(#{@candidate_1.id}).count", "Vote.find_all_by_candidate_id(#{@candidate_2.id}).count"] do
      assert_difference ['Vote.count', "User.find(#{@user.id}).votes.count"], 2 do
        select_vote_for @candidate_1, 1
        select_vote_for @candidate_2, -2

        click_on 'update votes'
      end
    end

    @user.reload
    assert_equal +1, @user.vote_for_candidate(@candidate_1.id)
    assert_equal -2, @user.vote_for_candidate(@candidate_2.id)
  end


  test "user with existing votes should update his votes" do
    click_on 'Votez'

    select_vote_for @candidate_1, 1
    select_vote_for @candidate_2, -2

    click_on 'update votes'

    assert_no_difference ["Vote.find_all_by_candidate_id(#{@candidate_1.id}).count",
                          "Vote.find_all_by_candidate_id(#{@candidate_2.id}).count",
                          'Vote.count', '@user.votes.count'] do
      select_vote_for @candidate_1, 0
      select_vote_for @candidate_2, 2

      click_on 'update votes'
    end

    @user.reload
    assert_equal 0, @user.vote_for_candidate(@candidate_1.id)
    assert_equal 2, @user.vote_for_candidate(@candidate_2.id)

  end


  def select_vote_for candidate, vote
    choose "user_vote_for_candidate_#{candidate.id}_#{vote}"
  end


end
