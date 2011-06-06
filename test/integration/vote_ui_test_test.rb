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
        select '+1', :from => "user[vote_for_candidate_#{@candidate_1.id}]"
        select '-2', :from => "user[vote_for_candidate_#{@candidate_2.id}]"
        click_on 'update votes'
      end
    end

    @user.reload
    assert_equal +1, @user.vote_for_candidate(@candidate_1.id)
    assert_equal -2, @user.vote_for_candidate(@candidate_2.id)
  end


  test "user with existing votes should update his votes" do
    click_on 'Votez'

    select '+1', :from => "user[vote_for_candidate_#{@candidate_1.id}]"
    select '-2', :from => "user[vote_for_candidate_#{@candidate_2.id}]"

    click_on 'update votes'

    assert_no_difference ["Vote.find_all_by_candidate_id(#{@candidate_1.id}).count",
                          "Vote.find_all_by_candidate_id(#{@candidate_2.id}).count",
                          'Vote.count', '@user.votes.count'] do
      select '+0', :from => "user[vote_for_candidate_#{@candidate_1.id}]"
      select '+2', :from => "user[vote_for_candidate_#{@candidate_2.id}]"
      click_on 'update votes'
    end

    @user.reload
    assert_equal 0, @user.vote_for_candidate(@candidate_1.id)
    assert_equal 2, @user.vote_for_candidate(@candidate_2.id)

  end


end
