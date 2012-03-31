# coding: utf-8
require 'test_helper' unless eval "begin; Spork.using_spork?; rescue; false; end"

class Admin::CandidatesUiTest < ActionDispatch::IntegrationTest

  setup do
    @admin = Factory :admin_user
    ui_sign_as_admin @admin
  end

  test "admin should create candidate" do

    candidate = Factory.build :candidate

    click_on 'Candidate'
    click_link 'Ajouter nouveau'
    assert page.has_content? 'Add New'

    assert_difference 'Candidate.count' do
      fill_in 'candidate_name', :with => candidate.name
      click_on 'Save'
    end

  end

  test "admin should list candidates" do
    candidate = Factory :candidate

    click_on 'Candidate'

    assert page.has_content? candidate.name
  end

  test "admin should edit candidate" do
    candidate = Factory :candidate
    click_on 'Candidate'
    assert page.has_content? candidate.name

    visit "/admin/candidates/edit/#{candidate.id}"

    new_name = "new name"
    assert_difference "Candidate.find_all_by_name('#{new_name}').count" do
      assert_difference "Candidate.find_all_by_name('#{candidate.name}').count", -1 do
        fill_in 'candidate_name', :with => new_name
        click_button 'Save'
      end
    end
  end

end
