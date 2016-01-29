require 'test_helper'

class ImageTest < ActiveSupport::TestCase
  test 'url should not be null' do
    image = Image.new
    assert_predicate image, :invalid?
    assert_equal(["can't be blank"], image.errors.messages[:url])
  end

  test 'url should not be empty string' do
    image = Image.new(url: "")
    assert_predicate image, :invalid?
    assert_equal(["can't be blank"], image.errors.messages[:url])
  end

  test 'image with valid url' do
    image = Image.new(url: "http://www.image.com/images/1")
    assert_predicate image, :valid?
  end

  test 'image with invalid url' do
    image = Image.new(url: 'h//www.image.com')
    assert_predicate image, :invalid?
    assert_equal(['invalid URL'], image.errors.messages[:url])
  end
end
