require 'test_helper'
class TagsControllerTest < ActionController::TestCase
  VALID_IMAGE_URL = 'https://upload.wikimedia.org/wikipedia/en/thumb/e/e9/Ruby_on_Rails.svg/791px-Ruby_on_Rails.svg.png'

  setup do
    2.times { create_image_with_tag('red') }
    2.times { create_image_with_tag('green') }
    2.times { create_image_with_tag('blue') }
    2.times { create_image_with_tag('red, blue') }
  end

  test 'show all images with tag #green' do
    get :show, tag_name: 'green'
    assert_response :success
    assert_select 'a.tag_link' do |elements|
      assert_equal ['/tags/green'] * 2, elements.map { |el| el[:href] }
    end
  end

  test 'show all images with tag #blue' do
    get :show, tag_name: 'blue'
    assert_response :success
    assert_select 'a.tag_link' do |elements|
      assert_equal %w(/tags/blue /tags/blue /tags/red /tags/blue /tags/red /tags/blue),
                   elements.map { |el| el[:href] }
    end
  end

  private

  def create_image_with_tag(tag_name)
    Image.create!(url: VALID_IMAGE_URL, tag_list: tag_name)
  end
end
