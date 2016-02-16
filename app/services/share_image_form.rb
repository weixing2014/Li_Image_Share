class ShareImageForm
  include ActiveModel::Model

  attr_accessor :image_id, :recipient, :subject
end
