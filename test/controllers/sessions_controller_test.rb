require 'test_helper'
class SessionsControllerTest < ActionController::TestCase
  test 'fail to log in with invalid information' do
    post :create, session: { email: 'user@invalid', password: 'foo' }

    assert_response :unprocessable_entity
    assert_select 'span.help-block' do |elements|
      assert_equal ['is invalid',
                    'is too short (minimum is 6 characters)'],
                   elements.map(&:text)
    end
    assert_select 'form#new_session'
    assert_not is_logged_in?
  end

  test 'fail to log in with incorrect email/password combination' do
    post :create, session: { email: 'hello@world.com', password: 'foobar' }

    assert_response :not_found
    assert_equal 'Invalid email/password combination', flash[:error]
    assert_select 'form#new_session'
    assert_not is_logged_in?
  end

  test 'log in user successfully' do
    post :create, session: { email: 'hello@world.com', password: 'password' }

    assert_redirected_to root_path
    assert is_logged_in?
  end

  test 'log out user' do
    delete :destroy

    assert_redirected_to root_path
    assert_not is_logged_in?
  end
end
