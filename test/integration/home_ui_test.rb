require "integration_test_helper"

class HomeUiTest < ActionDispatch::IntegrationTest

  setup do
    ui_sign_out
  end

  test "home should say vote de valeur" do
    visit '/'
    assert page.has_content? 'Vote De Valeur'
  end

  test "home should display sign in" do
    visit '/'
    assert page.has_content? "sign in"
  end


  test "user sign in test" do
    assert !page.has_content?("signed in as")

    user = Factory :user
    ui_sign_in user
    puts page.body
    assert page.has_content?("signed in as #{user.email}")
  end
end