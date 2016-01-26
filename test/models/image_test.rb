require 'test_helper'

class ImageTest < ActiveSupport::TestCase
  test "url should not be null" do
    image = Image.new
    assert image.invalid?
    assert_equal({url: ["can't be blank"]}, image.errors.messages)
  end

  test "url should not be empty string" do
    image = Image.new(url: "")
    assert image.invalid?
    assert_equal({url: ["can't be blank"]}, image.errors.messages)
  end

  test "can save valid image" do
    image = Image.new(url: "http://www.image.com/images/1")
    assert image.save
  end
end
