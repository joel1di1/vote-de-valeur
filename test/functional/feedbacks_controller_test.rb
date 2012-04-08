require 'test_helper' unless eval "begin; Spork.using_spork?; rescue; false; end"

class FeedbacksControllerTest < ActionController::TestCase

  test 'new should display form' do
    user = FactoryGirl.create :user
    sign_in user

    get :new 

    assert_response :success
    assert_not_nil assigns[:feedback]
  end

  test 'create feedback should drop every params in text' do
    user = FactoryGirl.create :user
    sign_in user
    some_email = FactoryGirl.generate :email

    assert_difference 'Feedback.count' do
      post :create, :test_1 => 'test 1 value', :test_2 => some_email
    end

    feedback = Feedback.last
    answers = ActiveSupport::JSON.decode(feedback.answers)

    assert_equal 'test 1 value', answers['test_1']
    assert_equal some_email, answers['test_2']
  end

end
