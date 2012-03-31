# coding: utf-8
require 'test_helper' unless eval "begin; Spork.using_spork?; rescue; false; end"

class Admin::AdminUiTest < ActionDispatch::IntegrationTest

  setup do
    @admin = Factory :admin_user
  end

  test "admin should access typus" do
    ui_sign_as_admin @admin
    assert page.has_content? 'Tableau de bord'
  end
end
