class Image < ActiveRecord::Base
  validates :url, presence: true, url: true
end
