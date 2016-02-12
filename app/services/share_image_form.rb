class ShareImageForm
  include ActiveModel::Model

  attr_accessor :recipient, :subject

  validates :recipient, presence: true, format: { with: /.+@.+\..+/i }
end
