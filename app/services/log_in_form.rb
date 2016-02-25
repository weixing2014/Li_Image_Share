class LogInForm
  include ActiveModel::Model

  attr_accessor :email, :password

  validates :email,
            presence: true,
            length: { maximum: 255 },
            email_format: { message: 'is invalid' }

  validates :password, presence: true, length: { minimum: 6 }
end