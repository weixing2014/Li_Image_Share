require 'test_helper'
class TagsControllerTest < ActionController::TestCase
  VALID_IMAGE_URL = 'https://upload.wikimedia.org/wikipedia/en/thumb/e/e9/Ruby_on_Rails.svg/791px-Ruby_on_Rails.svg.png'

  test 'show tags in descendant order of frequency' do
    tags = %w(first second third)
    tags.each_with_index do |_, index|
      Image.create!(url: VALID_IMAGE_URL, tag_list: tags[0..index])
    end

    get :index

    assert_response :success
    assert_select 'a.tag_link' do |elements|
      assert_equal tags.map { |tag| "##{tag}" }, elements.map(&:text)
      assert_equal tags.map { |tag| "/images?tag=#{tag}" },
                   elements.map { |el| el[:href] }
    end
  end
end
