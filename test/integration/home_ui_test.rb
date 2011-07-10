# coding: utf-8
require "integration_test_helper"

class HomeUiTest < ActionDispatch::IntegrationTest

  setup do
    ui_sign_out
  end

  test 'home should show sign_up form for unauthenticated users' do
    visit '/'
    assert page.has_selector? '#new_user'
  end

  test 'home should not show sign_up form for authenticated users' do
    ui_sign_in Factory :user
    visit '/'
    assert !page.has_selector?('#new_user')
  end

  test 'home should not show sign_up form just sign up users' do

    user = Factory.build :user
    visit '/'
    assert page.has_selector?('#new_user')

    fill_sign_up_form(user)

    click_on 'user_submit'
  end

  test "home should display inscription fields" do
    visit '/'
    assert page.has_content? 'Enregistrement'
    assert page.has_field? 'user[email]'
    assert page.has_field? 'user[first_name]'
    assert page.has_field? 'user[last_name]'
    assert page.has_field? 'user[postal_code]'
    assert page.has_field? 'user[public]'
  end

  test "home should say vote de valeur" do
    visit '/'
    assert page.has_content? 'Vote De Valeur'
  end

  test "home should display sign in" do
    visit '/'
    assert page.has_selector? "#user_sign_in"
  end

  test "user sign in test" do
    assert !page.has_content?("signed in as")

    user = Factory :user
    ui_sign_in user
    assert page.has_content? user.email
  end
end