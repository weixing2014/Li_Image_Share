require 'test_helper'

class LogInFormTest < ActiveSupport::TestCase
  setup do
    @log_in_form = LogInForm.new(email: 'hello@world.com', password: 'foobar')
  end

  test 'should be valid' do
    assert_predicate @log_in_form, :valid?
  end

  test 'email should be present' do
    @log_in_form.email = '   '
    assert_predicate @log_in_form, :invalid?
  end

  test 'email should not be too long' do
    @log_in_form.email = 'a' * 244 + '@example.com'
    assert_predicate @log_in_form, :invalid?
  end

  test 'email validation should accept valid addresses' do
    valid_addresses = %w(user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.com)

    valid_addresses.each do |valid_address|
      @log_in_form.email = valid_address
      assert_predicate @log_in_form, :valid?
    end
  end

  test 'email validation should reject invalid addresses' do
    valid_addresses = %w(user@example,com user_at_foo.org user.name@example
                         foo@bar_baz.com foo@bar+baz.com)

    valid_addresses.each do |valid_address|
      @log_in_form.email = valid_address
      assert_predicate @log_in_form, :invalid?
    end
  end

  test 'password should be present' do
    @log_in_form.password = ' ' * 6
    assert_predicate @log_in_form, :invalid?
  end

  test 'password should have a minimum length' do
    @log_in_form.password = 'a' * 5
    assert_predicate @log_in_form, :invalid?
  end
end
