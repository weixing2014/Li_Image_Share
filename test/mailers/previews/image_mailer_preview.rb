# Preview all emails at http://localhost:3000/rails/mailers/image_mailer
class ImageMailerPreview < ActionMailer::Preview
  def share_image_email
    ImageMailer.share_image_email(Image.first, 'foo@bar.com', 'Hello, world')
  end

  def share_image_email_whith_default_subject
    ImageMailer.share_image_email(Image.first, 'foo@bar.com', nil)
  end
end
