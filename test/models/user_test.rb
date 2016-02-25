require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @user = User.new(name: 'Li', email: 'user@example.com',
                     password: 'foobar', password_confirmation: 'foobar')
  end

  test 'should be valid' do
    assert_predicate @user, :valid?
  end

  test 'name should be present' do
    @user.name = '   '
    assert_predicate @user, :invalid?
  end

  test 'email should be present' do
    @user.email = '   '
    assert_predicate @user, :invalid?
  end

  test 'name should not be too long' do
    @user.name = 'a' * 51
    assert_predicate @user, :invalid?
  end

  test 'email should not be too long' do
    @user.email = 'a' * 244 + '@example.com'
    assert_predicate @user, :invalid?
  end

  test 'email validation should accept valid addresses' do
    valid_addresses = %w(user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.com)

    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert_predicate @user, :valid?
    end
  end

  test 'email validation should reject invalid addresses' do
    valid_addresses = %w(user@example,com user_at_foo.org user.name@example
                         foo@bar_baz.com foo@bar+baz.com)

    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert_predicate @user, :invalid?
    end
  end

  test 'email address should be unique' do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save!
    assert_predicate duplicate_user, :invalid?
  end

  test 'password should be present' do
    @user.password = ' ' * 6
    @user.password_confirmation = ' ' * 6
    assert_predicate @user, :invalid?
  end

  test 'password should have a minimum length' do
    @user.password = 'a' * 5
    @user.password_confirmation = 'a' * 5
    assert_predicate @user, :invalid?
  end

  test 'authenticated? should return false for a user with nil digest' do
    assert_not @user.authenticated?('')
  end
end
