# Preview all emails at http://localhost:3000/rails/mailers/image_mailer
class ImageMailerPreview < ActionMailer::Preview
  def share_image_email
    ImageMailer.share_image_email(Image.first, 'foo@bar.com', 'Hello, world')
  end

  def share_image_email_with_default_subject
    ImageMailer.share_image_email(Image.first, 'foo@bar.com', '  ')
  end
end
