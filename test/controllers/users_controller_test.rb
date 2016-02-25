require 'test_helper'
class UsersControllerTest < ActionController::TestCase
  test 'fail to sign up with invalid information' do
    assert_no_difference 'User.count' do
      post :create, user: { name: ' ',
                            email: 'user@invalid',
                            password: 'foo',
                            password_confirmation: 'bar' }
    end

    assert_response :unprocessable_entity
    assert_select 'span.help-block' do |elements|
      assert_equal ["can't be blank",
                    'is invalid',
                    'is too short (minimum is 6 characters)',
                    "doesn't match Password"],
                   elements.map(&:text)
    end
    assert_select 'form#new_user'
    assert_not is_logged_in?
  end

  test 'create a new user successfully' do
    assert_difference 'User.count', 1 do
      post :create, user: { name: 'Li Zhang',
                            email: 'user@example.com',
                            password: 'foobar',
                            password_confirmation: 'foobar' }
    end

    assert_redirected_to root_path
    assert_equal 'Li Zhang', User.last.name
    assert_equal 'user@example.com', User.last.email
    assert_equal 'You have successfully signed up!', flash[:notice]
    assert is_logged_in?
  end
end
