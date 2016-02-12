class ImageMailer < ActionMailer::Base
  default from: 'ycy828f@gmail.com'

  def image_sharing_email(sharing_email, subject, url)
    @image_url = url
    mail to: sharing_email, subject: subject
  end
end
