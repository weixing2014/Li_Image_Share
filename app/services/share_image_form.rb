class ShareImageForm
  include ActiveModel::Model

  attr_accessor :recipient, :subject

  validates :recipient,
            presence: true,
            email_format: { message: 'is invalid' }
end
