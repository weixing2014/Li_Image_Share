require 'test_helper'

class ImageTest < ActiveSupport::TestCase
  test 'url should not be null' do
    image = Image.new(tag_list: 'good')
    assert_predicate image, :invalid?
    assert_equal(["can't be blank"], image.errors.messages[:url])
  end

  test 'url should not be blank' do
    image = Image.new(url: " ", tag_list: 'good')
    assert_predicate image, :invalid?
    assert_equal(["can't be blank"], image.errors.messages[:url])
  end

  test 'tag_list should not be null' do
    image = Image.new(url: "http://www.image.com/images/1")
    assert_predicate image, :invalid?
    assert_equal(["can't be blank"], image.errors.messages[:tag_list])
  end

  test 'tag_list should not be blank' do
    image = Image.new(url: "http://www.image.com/images/1", tag_list: ' ')
    assert_predicate image, :invalid?
    assert_equal(["can't be blank"], image.errors.messages[:tag_list])
  end

  test 'image with valid url and tags list' do
    image = Image.new(url: "http://www.image.com/images/1", tag_list: 'good')
    assert_predicate image, :valid?
  end

  test 'image with invalid url' do
    image = Image.new(url: 'h//www.image.com', tag_list: 'good')
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
