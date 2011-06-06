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
        fill_in "user[vote_for_candidate_#{@candidate_1.id}]", :with => 1
        fill_in "user[vote_for_candidate_#{@candidate_2.id}]", :with => -2
        click_on 'update votes'
      end
    end

    visit '/votes'
    assert_equal "1", find_field("user[vote_for_candidate_#{@candidate_1.id}]").value
    assert_equal "-2", find_field("user[vote_for_candidate_#{@candidate_2.id}]").value
  end

  test "test input should be considered as nil" do
    click_on 'Votez'

    fill_in "user[vote_for_candidate_#{@candidate_1.id}]", :with => 'youpi23'
    fill_in "user[vote_for_candidate_#{@candidate_2.id}]", :with => '123t'
    click_on 'update votes'

    visit '/votes'
    assert_nil find_field("user[vote_for_candidate_#{@candidate_1.id}]").value
    assert_nil find_field("user[vote_for_candidate_#{@candidate_2.id}]").value
  end


  test "user with existing votes should update his votes" do
    click_on 'Votez'

    fill_in "user[vote_for_candidate_#{@candidate_1.id}]", :with => 1
    fill_in "user[vote_for_candidate_#{@candidate_2.id}]", :with => -2
    click_on 'update votes'

    assert_no_difference ["Vote.find_all_by_candidate_id(#{@candidate_1.id}).count",
                          "Vote.find_all_by_candidate_id(#{@candidate_2.id}).count",
                          'Vote.count', '@user.votes.count'] do
      fill_in "user[vote_for_candidate_#{@candidate_1.id}]", :with => 5
      fill_in "user[vote_for_candidate_#{@candidate_2.id}]", :with => -5
      click_on 'update votes'
    end
  end



end
