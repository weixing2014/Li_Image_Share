require 'flow_test_helper'

class ImagesCrudTest < FlowTestCase
  VALID_IMAGE_URL = 'https://upload.wikimedia.org/wikipedia/en/thumb/e/e9/Ruby_on_Rails.svg/791px-Ruby_on_Rails.svg.png'
  setup do
    Capybara.default_driver = Capybara.javascript_driver
    Capybara.default_max_wait_time = 5
  end

  test 'create a new image' do
    visit root_path

    assert page.has_title? 'LiImageShare'

    click_on 'New Image'

    click_on 'Cancel'

    assert page.has_current_path? root_path

    click_on 'New Image'

    assert page.has_current_path? new_image_path
    assert label_is_present? 'image_url'
    assert label_is_present? 'image_tag_list'

    assert_equal ['* Url', '* Tags'], form_labels

    fill_in '* Url', with: 'invalid'
    click_on 'Create Image'

    assert_equal 2, number_of_input_error_messages_in_page
    assert_equal 'is invalid!',
                 input_field_error_message_of('.image_url')
    assert_equal "can't be blank",
                 input_field_error_message_of('.image_tag_list')

    fill_in '* Url', with: VALID_IMAGE_URL
    fill_in '* Tags', with: 'rails, wow'

    click_on 'Create Image'

    assert page.has_current_path? image_path(Image.last)

    assert_equal %w(#rails #wow), image_tags
    assert image_present?(Image.last.url)
  end

  test 'edit an image' do
    image = create_image tag_list: 'awesome, good'

    visit root_path

    assert page.has_title? 'LiImageShare'

    click_on_image image

    assert_image_and_tags_show_correctly image

    click_on 'Go Back'

    assert page.has_current_path? images_path

    click_on_image image

    assert_image_and_tags_show_correctly image

    click_on 'Edit it'

    assert page.has_current_path? edit_image_path(image)

    assert_equal '* Tags', update_image_form_label
    assert_equal 'awesome, good', input_field_value_for('#image_tag_list')
    assert_equal 'Update Image', input_field_value_for('input[type=submit]')

    click_on 'Cancel'

    assert page.has_current_path? image_path(image)
    assert image_present? image.url

    assert_equal %w(#awesome #good), image_tags

    click_on 'Edit it'

    assert page.has_current_path? edit_image_path(image)

    fill_in '* Tags', with: 'rails'
    click_on 'Update Image'

    assert page.has_current_path? image_path(image)
    assert image_present? image.url
    assert_equal ['#rails'], image_tags
  end

  test 'delete an image' do
    image = create_image tag_list: 'red, blue'

    visit root_path

    assert page.has_title? 'LiImageShare'

    click_on_image image

    assert_image_and_tags_show_correctly image

    dismiss_confirm 'Are you sure to delete this image?' do
      click_on 'Delete it'
    end

    assert_image_and_tags_show_correctly image

    accept_confirm 'Are you sure to delete this image?' do
      click_on 'Delete it'
    end

    assert page.has_current_path? root_path
    assert image_not_present? image.url
  end

  test 'view images associated with a tag' do
    images = []
    images << create_image(tag_list: 'red, green, blue')
    images << create_image(tag_list: 'red, green')
    images << create_image(tag_list: 'red')

    visit root_path

    assert page.has_title? 'LiImageShare'

    click_on 'Tags'

    assert page.has_current_path? tags_path

    assert_equal %w(#red #green #blue), tags_list

    click_on '#green'

    assert page.has_current_path? images_path(tag: 'green')

    assert_equal 2, number_of_images_in_page

    images[0..1].each do |image|
      assert image_present? image.url
    end

    assert image_not_present? images[2]

    click_on 'Images'

    assert page.has_current_path? images_path
  end

  private

  def image_present?(url)
    page.has_selector? "img[src='#{url}']"
  end

  def image_not_present?(url)
    page.has_no_selector? "img[src='#{url}']"
  end

  def click_on_image(image)
    find("img[src='#{image.url}']").click
  end

  def image_tags
    page.all('.container > hr~a').map(&:text)
  end

  def create_image(url: VALID_IMAGE_URL, tag_list: %w(tag1, tag2))
    Image.create!(url: url, tag_list: tag_list)
  end

  def assert_image_and_tags_show_correctly(image)
    assert page.has_current_path? image_path(image)
    assert image_present? image.url
    assert_equal image.tag_list.map { |tag| "##{tag}" }, image_tags
  end

  def label_is_present?(field)
    page.has_selector? "label[for=#{field}] abbr[title=required]"
  end

  def form_labels
    page.all('.control-label').map(&:text)
  end

  def input_field_error_message_of(input_selector)
    find("#{input_selector}.has-error > .help-block").text
  end

  def update_image_form_label
    find('.control-label[for=image_tag_list]').text
  end

  def input_field_value_for(field_selector)
    find(field_selector)[:value]
  end

  def tags_list
    page.all('.js-tag-link').map(&:text)
  end

  def number_of_input_error_messages_in_page
    page.all('.help-block').count
  end

  def number_of_images_in_page
    page.all('img').count
  end
end
