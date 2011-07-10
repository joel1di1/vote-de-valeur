# coding: utf-8
require 'integration_test_helper'

class SignUpUiTest < ActionDispatch::IntegrationTest

  setup do
    ui_sign_out
  end

  test "sign up before election start must send confirmation message" do
    # setup
    user = Factory.build :user

    DateHelper.election_starts_at = 1.days.from_now
    DateHelper.election_ends_at = 2.days.from_now

    # actions
    visit '/'
    fill_sign_up_form user
    assert_difference 'ActionMailer::Base.deliveries.count' do
      click_on 'user_submit'
    end

    mail = ActionMailer::Base.deliveries.last
    assert_match /Le bureau de vote virtuel ouvrira le/, mail.encoded
  end


  test "sign up in election time must send confirmation message" do
    # setup
    user = Factory.build :user

    DateHelper.election_starts_at = 1.day.ago
    DateHelper.election_ends_at = 1.day.from_now

    # actions
    visit '/'
    fill_sign_up_form user
    assert_difference 'ActionMailer::Base.deliveries.count' do
      click_on 'user_submit'
    end

    mail = ActionMailer::Base.deliveries.last
    assert_match /Le bureau de vote virtuel est ouvert/, mail.encoded
  end

end
