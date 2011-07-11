# coding: utf-8
require 'integration_test_helper'

class SignUpUiTest < ActionDispatch::IntegrationTest

  setup do
    ui_sign_out
  end

  test "sign up before election send to thanks page" do
    # setup
    user = Factory.build :user

    DateHelper.election_starts_at = 1.days.from_now
    DateHelper.election_ends_at = 2.days.from_now

    # actions
    visit '/'
    fill_sign_up_form user
    click_on 'user_submit'

    assert page.has_content? 'Merci'
  end


  test "sign up during election send to thanks page" do
    # setup
    user = Factory.build :user

    DateHelper.election_starts_at = 1.days.ago
    DateHelper.election_ends_at = 2.days.from_now

    # actions
    visit '/'
    fill_sign_up_form user
    click_on 'user_submit'

    assert page.has_content? 'Merci'
  end


  test "sign up before election start must send confirmation message" do
    # setup
    user = Factory.build :user

    DateHelper.election_starts_at = 1.days.from_now
    DateHelper.election_ends_at = 2.days.from_now

    # actions
    visit '/'
    fill_sign_up_form user

    assert_difference ['ActionMailer::Base.deliveries.count', 'User.count'] do
      click_on 'user_submit'
    end

    mail = ActionMailer::Base.deliveries.last
    assert ! mail.body.to_s.match(/#{User.find_by_email(user.email).access_token}/)
    assert_match /Un mail vous sera envoy. . l'ouverture du bureau de vote/, mail.body
  end


  test "sign up in election time must send confirmation message" do
    # setup
    user = Factory.build :user

    DateHelper.election_starts_at = 1.day.ago
    DateHelper.election_ends_at = 1.day.from_now

    # actions
    visit '/'
    fill_sign_up_form user
    assert_difference ['ActionMailer::Base.deliveries.count', 'User.count'] do
      click_on 'user_submit'
    end

    mail = ActionMailer::Base.deliveries.last
    assert_match /http:\/\/.*\/users\/access\/#{User.find_by_email(user.email).access_token}/, mail.body
  end

end
