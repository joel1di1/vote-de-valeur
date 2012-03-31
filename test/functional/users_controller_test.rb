require 'test_helper' unless eval "begin; Spork.using_spork?; rescue; false; end"

class UsersControllerTest < ActionController::TestCase

  setup do
  end

  test 'user access with wrong token should be redirected to home page' do
    get :access, :id => 'unkown'
    assert_redirected_to root_path
    get :access, :id => ' '
    assert_redirected_to root_path
  end

  test 'user access with correct token should sign user and set key' do
    user = Factory :user
    assert ! session[VotesController::TOKEN_VALIDATED_KEY]

    get :access, :id => user.access_token

    assert_user_signed_in user
    assert session[VotesController::TOKEN_VALIDATED_KEY]
  end

  def assert_user_signed_in user
    warden_session_key = session['warden.user.user.key']
    assert_not_nil warden_session_key, 'user not signed in, no warden key'
    assert_equal user.id, warden_session_key[1][0], 'user not signed in, warden key is not user id'
  end

  def count_users_with_json_call
    get :count, :format => :json

    assert_response :success
    json = JSON.parse(response.body).with_indifferent_access
    count = json[:users][:count]
    count
  end

  test 'count json should return user count' do
    count = count_users_with_json_call()
    assert_not_nil count

    assert_difference 'count_users_with_json_call()' do
      Factory :user
    end

  end

  test 'count js should return user count with user_count as prefix' do
    get :count, :format => :js

    assert_response :success
    assert response.body.start_with? 'function user_count(){'
  end

  test 'count js with jsonp param should return user count with param as prefix' do
    get :count, :format => :js, :jsonp => 'prefix'

    assert_response :success
    assert response.body.start_with? 'function prefix(){'
  end

end
