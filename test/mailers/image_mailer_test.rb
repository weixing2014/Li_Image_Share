require 'test_helper'

class ImageMailerTest < ActionMailer::TestCase
  VALID_IMAGE_URL = 'https://upload.wikimedia.org/wikipedia/en/thumb/e/e9/Ruby_on_Rails.svg/791px-Ruby_on_Rails.svg.png'

  setup do
    @image = Image.create!(url: VALID_IMAGE_URL, tag_list: 'good')
  end

  test 'share image email with default subject' do
    email =
      ImageMailer.share_image_email(@image, 'foo@bar.com', '  ').deliver_now

    assert_not ActionMailer::Base.deliveries.empty?
    assert_equal ['no-reply@appfolio.com'], email.from
    assert_equal ['foo@bar.com'], email.to
    assert_equal 'An image shared from FunGraph', email.subject

    [:text_part, :html_part].each do |part|
      email_body = email.send(part).body.to_s
      assert_includes email_body, @image.url
    end
  end

  test 'share image email with customized subject' do
    email =
      ImageMailer.share_image_email(@image, 'foo@bar.com', 'Title').deliver_now

    assert_not ActionMailer::Base.deliveries.empty?
    assert_equal ['no-reply@appfolio.com'], email.from
    assert_equal ['foo@bar.com'], email.to
    assert_equal 'Title', email.subject

    [:text_part, :html_part].each do |part|
      email_body = email.send(part).body.to_s
      assert_includes email_body, @image.url
    end
  end
end
