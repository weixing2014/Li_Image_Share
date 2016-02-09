require 'test_helper'
class TagsControllerTest < ActionController::TestCase
  VALID_IMAGE_URL = 'https://upload.wikimedia.org/wikipedia/en/thumb/e/e9/Ruby_on_Rails.svg/791px-Ruby_on_Rails.svg.png'

  test 'show tags in descendant order of frequency' do
    tags = %w(fifth fourth third second first)
    tags.each_with_index do |tag, index|
      (index + 1).times { Image.create!(url: VALID_IMAGE_URL, tag_list: tag) }
    end

    get :index

    assert_response :success
    assert_select 'a.tag_link' do |elements|
      assert_equal tags.map { |tag| "##{tag}" }.reverse, elements.map(&:text)
      assert_equal tags.map { |tag| "/images?tag=#{tag}" }.reverse,
                   elements.map { |el| el[:href] }
    end
  end
end
