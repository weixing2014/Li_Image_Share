require 'test_helper'

class ShareImageFormTest < ActiveSupport::TestCase
  test 'should have email recipient' do
    form = ShareImageForm.new(recipient: 'Sarah')
    assert_equal 'Sarah', form.recipient
  end

  test 'should have email subject' do
    form = ShareImageForm.new(subject: 'image')
    assert_equal 'image', form.subject
  end
end
