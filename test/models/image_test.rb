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
    assert_equal(['is invalid!'], image.errors.messages[:url])
  end

  test 'remove unused tag after deleting image' do
    image = Image.create!(url: "http://www.image.com/images/1", tag_list: 'awesome')

    assert_difference('ActsAsTaggableOn::Tag.count', -1) do
      assert_difference('ActsAsTaggableOn::Tagging.count', -1) do
        image.destroy!
      end
    end

    assert_not ActsAsTaggableOn::Tag.exists?(name: 'awesome')
  end
end
