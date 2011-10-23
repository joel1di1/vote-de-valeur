require 'test_helper'
require 'capybara/rails'

class ActionDispatch::IntegrationTest
  include Capybara::DSL

  def sign_up user
    visit '/'
    click_link 'Continuer'
    fill_sign_up_form user
    click_on 'next'
  end

  def ui_sign_out
    visit '/users/sign_out'
  end

  def ui_sign_in user
    visit "/users/access/#{user.access_token}"
  end


  def ui_sign_out_admin
    visit '/admin/session/'
  end

  def ui_sign_as_admin admin
    ui_sign_out_admin
    visit '/admin'
    fill_in 'typus_user[email]', :with => @admin.email
    fill_in 'typus_user[password]', :with => @admin.password
    click_on 'Sign in'
  end

  def fill_sign_up_form(user)
    fill_in 'user[email]', :with => user.email
    fill_in 'user[first_name]', :with => user.first_name.to_s
    fill_in 'user[last_name]', :with => user.last_name.to_s
    fill_in 'user[postal_code]', :with => user.postal_code.to_s
    check 'user[public]' if user.public?
  end

end
