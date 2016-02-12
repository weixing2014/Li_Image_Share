class ImageMailer < ApplicationMailer
  def share_image_email(image, recipient, subject)
    @image = image

    mail(to: recipient, subject: subject)
  end
end
