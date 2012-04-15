# coding: utf-8
require 'test_helper' unless eval "begin; Spork.using_spork?; rescue; false; end"

class HomeUiTest < ActionDispatch::IntegrationTest

  setup do
    ui_sign_out
  end

  test 'sign_up page should show sign_up form for unauthenticated users' do
    visit '/'
    click_link 'next'
    assert page.has_selector? '#new_user'
  end

  test 'home should not show sign_up form for authenticated users' do
    ui_sign_in FactoryGirl.create :user
    visit '/'
    assert !page.has_selector?('#new_user')
  end

  test 'home should not show sign_up form just sign up users' do
    user = FactoryGirl.build :user
    visit '/'
    click_link 'next'

    assert page.has_selector?('#new_user')

    fill_sign_up_form(user)

    click_on 'next'
  end

  test "home should display inscription fields" do
    visit '/'
    click_link 'next'
    assert page.has_field? 'user[email]'
  end

  test "home should display sign in" do
    visit '/'
    assert page.has_selector? "#next.red"
  end

  test "user sign in test" do
    assert !page.has_content?("signed in as")

    user = FactoryGirl.create :user
    ui_sign_in user
    assert_equal '/votes/explanations', page.current_path
    assert page.has_content? 'Bienvenue'
  end
end