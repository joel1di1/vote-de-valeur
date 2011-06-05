require 'test_helper'
require 'capybara/rails'

class ActionDispatch::IntegrationTest
  include Capybara

  def ui_sign_out
    visit '/users/sign_out'
  end

  def ui_sign_in user
    ui_sign_out
    visit '/users/sign_in'
    fill_in 'user[email]', :with => user.email
    fill_in 'user[password]', :with => user.password
    click_on 'user_submit'
  end

end
