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

    fill_in 'user[email]', :with => user.email
    fill_in 'user[password]', :with => user.password
    fill_in 'user[password_confirmation]', :with => user.password
    fill_in 'user[first_name]', :with => user.first_name.to_s
    fill_in 'user[last_name]', :with => user.last_name.to_s
    fill_in 'user[postal_code]', :with => user.postal_code.to_s
    check 'user[public]' if user.public?

    click_on 'user_submit'
  end

  test "home should display inscription fields" do
    visit '/'
    assert page.has_content? 'Inscription'
    assert page.has_field? 'user[email]'
    assert page.has_field? 'user[password]'
    assert page.has_field? 'user[password_confirmation]'
    assert page.has_field? 'user[first_name]'
    assert page.has_field? 'user[last_name]'
    assert page.has_field? 'user[postal_code]'
    assert page.has_field? 'user[public]'
  end

  test "registration should " do
    visit '/'
    assert page.has_content? 'Inscription'
    assert page.has_field? 'user_email'
    assert page.has_field? 'user_password'
    assert page.has_field? 'user_password_confirmation'
    assert page.has_field? 'user_first_name'
    assert page.has_field? 'user_last_name'
    assert page.has_field? 'user_postal_code'
    assert page.has_field? 'user_public'
  end

  test "home should say vote de valeur" do
    visit '/'
    assert page.has_content? 'Vote De Valeur'
  end

  test "home should display sign in" do
    visit '/'
    assert page.has_selector? "#user_sign_in"
  end

  test 'to_confirmed page should show confirmation message' do
    visit '/home/to_confirmed'
  end

  test "user sign in test" do
    assert !page.has_content?("signed in as")

    user = Factory :user
    ui_sign_in user
    assert page.has_content? user.email
  end
end