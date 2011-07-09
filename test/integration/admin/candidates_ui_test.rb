# coding: utf-8
require "integration_test_helper"

class Admin::CandidatesUiTest < ActionDispatch::IntegrationTest

  setup do
    @admin = Factory :admin_user
    ui_sign_as_admin @admin
  end

  test "admin should create candidate" do

    candidate = Factory.build :candidate

    click_on 'Candidates'
    click_link 'Ajouter nouveau'
    assert page.has_content? 'Nouveau Candidate'

    assert_difference 'Candidate.count' do
      fill_in 'candidate_name', :with => candidate.name
      click_on 'Créer Candidate'
    end

  end

  test "admin should list candidates" do
    candidate = Factory :candidate

    click_on 'Candidates'

    assert page.has_content? candidate.name
  end

  test "admin should edit candidate" do
    candidate = Factory :candidate
    click_on 'Candidates'
    assert page.has_content? candidate.name

    visit "/admin/candidates/edit/#{candidate.id}"

    new_name = "new name"
    assert_difference "Candidate.find_all_by_name('#{new_name}').count" do
      assert_difference "Candidate.find_all_by_name('#{candidate.name}').count", -1 do
        fill_in 'candidate_name', :with => new_name
        click_button 'Sauvegarder Candidate'
      end
    end
  end

end
