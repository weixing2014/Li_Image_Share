require 'flow_test_helper'

class ShareImageFlowTest < FlowTestCase
  VALID_IMAGE_URL = 'https://upload.wikimedia.org/wikipedia/en/thumb/e/e9/Ruby_on_Rails.svg/791px-Ruby_on_Rails.svg.png'

  setup do
    Capybara.default_driver = Capybara.javascript_driver
    Capybara.default_max_wait_time = 5
  end

  test 'share an image' do
    image = create_image

    visit root_path

    assert page.has_title? 'LiImageShare'

    click_on 'Share'

    assert_blank_share_image_modal_shows image

    click_on 'Send'

    assert_equal "can't be blank", email_recipient_error_message

    click_on 'Close'

    assert page.has_css? '.js-share-image-modal', visible: false

    click_on 'Share'

    assert_blank_share_image_modal_shows image

    fill_in '* Recipient:', with: 'foo'

    click_on 'Send'

    assert_equal 'is invalid', email_recipient_error_message

    fill_in '* Recipient:', with: 'valid@appfolio.com'
    fill_in 'Subject:', with: 'Image Share'

    click_on 'Send'

    assert page.has_css? '.js-share-image-modal', visible: false

    assert_equal 'You have successfully shared the image to your friend!',
                 success_modal_message_text

    click_on 'Dismiss'

    assert page.has_css? '.js-share-image-success-modal', visible: false
  end

  test 'fail to share a non-exist image' do
    image = create_image

    visit root_path

    assert page.has_title? 'LiImageShare'

    click_on 'Share'

    assert_blank_share_image_modal_shows image

    image.destroy!

    fill_in '* Recipient:', with: 'valid@appfolio.com'
    fill_in 'Subject:', with: 'Image Share'

    not_found = 'Sorry, the image has been deleted so that it cannot be shared'
    accept_alert not_found do
      click_on 'Send'
    end

    assert page.has_css? '.js-share-image-modal', visible: false
  end

  private

  def create_image(url: VALID_IMAGE_URL, tag_list: %w(tag1, tag2))
    Image.create!(url: url, tag_list: tag_list)
  end

  def assert_blank_share_image_modal_shows(image)
    assert page.has_selector? "form[action='#{share_image_path(image.id)}']"
    assert page.has_selector? ".js-share-image-preview[src='#{image.url}']"
    assert page.has_no_selector? '.js-error-message'
  end

  def success_modal_message_text
    find('.js-share-image-success-modal .modal-body > p', visible: true).text
  end

  def email_recipient_error_message
    find('.share_image_form_recipient > .js-error-message').text
  end
end
