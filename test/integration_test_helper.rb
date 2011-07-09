require 'test_helper'
require 'capybara/rails'

class ActionDispatch::IntegrationTest
  include Capybara::DSL

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


  def ui_sign_out_admin
    visit '/admin/session/'
  end

  def ui_sign_as_admin admin
    ui_sign_out_admin
    visit '/admin'
    fill_in 'typus_user[email]', :with => @admin.email
    fill_in 'typus_user[password]', :with => @admin.password
    click_on 'Entrer'
  end

end
