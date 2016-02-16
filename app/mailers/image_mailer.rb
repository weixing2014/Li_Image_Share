class ImageMailer < ActionMailer::Base
  default from: 'ycy828f@gmail.com'

  def share_image_email(recipient, subject, url)
    @image_url = url
    mail to: recipient, subject: subject
  end
end
