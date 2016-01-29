require 'test_helper'

class UrlValidatorTest < ActiveSupport::TestCase
  setup do
    @validator = UrlValidator.new(attributes: 'a')
    @dummy_image = mock('image')
  end

  test 'validate valid URL' do
    @dummy_image.expects('errors').never

    @validator.validate_each(@dummy_image, 'url', 'http://www.example.com/images/1')
  end

  test 'validate all white space URL' do
    @dummy_image.expects('errors').never

    @validator.validate_each(@dummy_image, 'url', '     ')
  end

  test 'validate invalid URl' do
    error = mock('error')
    error_message = mock('error_message')

    @dummy_image.expects('errors').once.returns(error)
    error.expects('[]').with('url').once.returns(error_message)
    error_message.expects('<<').once

    @validator.validate_each(@dummy_image, 'url', 'You are right, I am invalid')
  end
end
