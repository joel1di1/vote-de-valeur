require "integration_test_helper"

class VoteUiTestTest < ActionDispatch::IntegrationTest

  setup do
    user = Factory :user
    candidate_1 = Factory :candidate
    candidate_2 = Factory :candidate

    ui_sign_in user

  end

  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
