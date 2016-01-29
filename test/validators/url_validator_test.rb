require 'test_helper'

class UrlValidatorTest < ActiveSupport::TestCase

  class Validatable
    include ActiveModel::Validations
    validates :url, url: true
  end

  setup do
    @validator = Validatable.new
  end

  test 'validates valid http URLs' do
    @validator.stubs(:url).returns('http://www.example.com/images/1')
    assert_predicate @validator, :valid?
  end

  test 'validates valid https URLs' do
    @validator.stubs(:url).returns('https://www.example.com/images/8')
    assert_predicate @validator, :valid?
  end

  test 'ignores empty string URLs' do
    @validator.stubs(:url).returns('   ')
    assert_predicate @validator, :valid?
  end

  test 'validates random strings as invalid URLs' do
    @validator.stubs(:url).returns('You are right, I am invalid')
    assert_predicate @validator, :invalid?
  end

  test 'validates URLs with wrong protocol types as invalid' do
    @validator.stubs(:url).returns('hp://www.something.com')
    assert_predicate @validator, :invalid?
  end

  test 'validates URLs missing colon as invalid' do
    @validator.stubs(:url).returns('http//www.example.com/images/2')
    assert_predicate @validator, :invalid?
  end
end
