require "integration_test_helper"

class HomeUiTest < ActionDispatch::IntegrationTest

  test "home should say vote de valeur" do
    visit '/'
    assert page.has_content? 'Vote De Valeur'
  end

  test "user sign in" do
    User.create
    visit '/'

  end
end