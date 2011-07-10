require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  setup do
  end

  test 'user access with wrong token should be redirected to home page' do
    get :access, :id => 'unkown'
    assert_redirected_to root_path
    get :access, :id => ' '
    assert_redirected_to root_path
  end

  test 'user access with correct token should sign user' do
    user = Factory :user

    get :access, :id => user.access_token

    assert_user_signed_in user
  end

  def assert_user_signed_in user
    warden_session_key = session['warden.user.user.key']
    assert_not_nil warden_session_key, 'user not signed in, no warden key'
    assert_equal user.id, warden_session_key[1][0], 'user not signed in, warden key is not user id'
  end

end
