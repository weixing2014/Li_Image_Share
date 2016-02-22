class ImageMailer < ApplicationMailer
  def share_image_email(image, recipient, subject)
    @image = image

    subject = 'An image shared from FunGraph' unless subject.present?

    mail(to: recipient, subject: subject)
  end
end
