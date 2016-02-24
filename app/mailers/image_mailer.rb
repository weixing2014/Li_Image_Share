class ImageMailer < ApplicationMailer
  def share_image_email(image, recipient, subject)
    @image = image

    subject = 'An image shared from FunGraph' if subject.blank?

    mail(to: recipient, subject: subject)
  end
end
