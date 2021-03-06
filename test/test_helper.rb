require 'rubygems'
require 'spork'


Spork.prefork do
  ENV["RAILS_ENV"] = "test"
  require File.expand_path('../../config/environment', __FILE__)
  require 'rails/test_help'

  class ActiveSupport::TestCase
  #  include Devise::TestHelpers

  #  fixtures :all

  end

  class ActionController::TestCase
      include Devise::TestHelpers
  end

  # integration test
  require 'capybara/rails'


  class ActionDispatch::IntegrationTest
    include Capybara::DSL

    def sign_up user
      visit '/'
      click_link "next"
      fill_sign_up_form user
      click_on 'Valider'
    end

    def ui_sign_out
      visit '/users/sign_out'
    end

    def ui_sign_in user
      visit "/users/access/#{user.access_token}"
    end

    def ui_sign_out_admin
      click_link 'Sign out'
    end

    def ui_sign_as_admin admin
      visit '/admin/session/new'
      fill_in 'typus_user[email]', :with => @admin.email
      fill_in 'typus_user[password]', :with => @admin.password
      click_on 'Sign in'
    end

    def fill_sign_up_form(user)
      fill_in 'user[email]', :with => user.email
    end

  end

  def mute_already_initialized_constant_warnings(&block)
    warn_level = $VERBOSE
    $VERBOSE = nil
    v = yield
    $VERBOSE = warn_level
    v
  end


end


Spork.each_run do
  # This code will be run each time you run your specs.
  mute_already_initialized_constant_warnings do
    Dir["#{Rails.root}/app/models/**/*.rb"].each do |model|
      load model
    end
  end
  
end

