require 'test_helper'
require 'capybara/rails'

class ActionDispatch::IntegrationTest
  include Capybara

  def ui_sign_in user
    visit '/users/sign_in'
    fill_in 'user[email]', user.email
    fill_in 'user[password]', user.password
    click_on ''
  end

end
