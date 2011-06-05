require "integration_test_helper"

class VoteUiTestTest < ActionDispatch::IntegrationTest

  setup do
    user = Factory :user
    candidate_1 = Factory :candidate
    candidate_2 = Factory :candidate

    ui_sign_in user

  end

  test "vote form should display candidates form" do
    click_on 'Votez'

    assert page.has_content? 'Votre vote'
  end
end
