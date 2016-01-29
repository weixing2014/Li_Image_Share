require 'URI'
class UrlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value.blank? || value =~ /\A#{URI.regexp}\z/
      record.errors[attribute] << (options[:messages] || 'invalid URL')
    end
  end
end
