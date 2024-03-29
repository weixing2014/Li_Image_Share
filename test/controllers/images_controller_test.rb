require 'test_helper'
class ImagesControllerTest < ActionController::TestCase
  VALID_IMAGE_URL = 'https://upload.wikimedia.org/wikipedia/en/thumb/e/e9/Ruby_on_Rails.svg/791px-Ruby_on_Rails.svg.png'

  test 'should get index' do
    get :index
    assert_response :success
  end

  test 'fail to create a new image with blank url' do
    assert_no_difference('Image.count') do
      post :create, image: { url: '', tag_list: 'good' }
    end

    assert_response :unprocessable_entity
    assert_select 'span.help-block' do |elements|
      assert_equal ["can't be blank"], elements.map(&:text)
    end
    assert_select 'form#new_image'
  end

  test 'fail to create a new image with blank tags list' do
    assert_no_difference('Image.count') do
      post :create, image: { url: VALID_IMAGE_URL, tag_list: '' }
    end

    assert_response :unprocessable_entity
    assert_select 'span.help-block' do |elements|
      assert_equal ["can't be blank"], elements.map(&:text)
    end
    assert_select 'form#new_image'
  end

  test 'create an image with tags successfully' do
    assert_difference('Image.count', 1) do
      post :create, image: { url: VALID_IMAGE_URL, tag_list: 'awesome, good' }
    end

    assert_equal %w(awesome good), Image.last.tag_list
    assert_redirected_to image_path(assigns(:image))
  end

  test 'show new image page' do
    get :new
    assert_response :success
    assert_select 'form#new_image'
  end

  test 'show an image' do
    image = create_image

    get :show, id: image.id

    assert_response :success
    assert_select 'img' do |elements|
      assert_equal [image.url], elements.map { |el| el[:src] }
    end
  end

  test 'fail to show an image' do
    assert_raises ActiveRecord::RecordNotFound do
      get :show, id: -1
    end
  end

  test 'display all saved images on index page' do
    7.times { create_image }

    get :index

    assert_response :success
    assert_select 'img.image-container__image' do |elements|
      assert_equal [VALID_IMAGE_URL] * Image.count,
                   elements.map { |el| el[:src] }
    end
  end

  test 'display all images with one tag on index page' do
    images = []
    2.times { images << create_image(tag_list: 'green') }
    2.times { create_image(tag_list: 'red') }

    get :index, tag: 'green'

    assert_response :success
    assert_select 'a.js-image-show' do |elements|
      assert_equal images.map { |image| image_path(image) },
                   elements.map { |el| el[:href] }
    end

    assert_select 'img.image-container__image' do |elements|
      assert_equal images.map(&:url), elements.map { |el| el[:src] }
    end
  end

  test 'display all images with more than one tag on index page' do
    images = []
    2.times { images << create_image(tag_list: 'red, blue') }
    2.times { images << create_image(tag_list: 'blue') }

    get :index, tag: 'blue'

    assert_response :success
    assert_select 'a.js-image-show' do |elements|
      assert_equal images.map { |image| image_path(image) },
                   elements.map { |el| el[:href] }
    end

    assert_select 'img.image-container__image' do |elements|
      assert_equal images.map(&:url), elements.map { |el| el[:src] }
    end
  end

  test 'display all images on index page if given tag is invalid' do
    images = []
    2.times { images << create_image(tag_list: 'red, blue') }
    2.times { images << create_image(tag_list: 'blue') }

    get :index, tag: 'invalid'

    assert_response :success
    assert_equal 'No such tag exists!', flash[:notice]

    assert_select 'a.js-image-show' do |elements|
      assert_equal images.map { |image| image_path(image) },
                   elements.map { |el| el[:href] }
    end

    assert_select 'img.image-container__image' do |elements|
      assert_equal images.map(&:url), elements.map { |el| el[:src] }
    end
  end

  test 'delete a saved image with a valid id' do
    image = create_image

    assert_difference('Image.count', -1) do
      delete :destroy, id: image.id
    end

    assert_equal 'Your selected image has been deleted.', flash[:notice]
    assert_redirected_to action: :index
  end

  test 'fail to delete a saved image with an invalid id' do
    assert_no_difference('Image.count') do
      assert_raises ActiveRecord::RecordNotFound do
        delete :destroy, id: -1
      end
    end
  end

  test 'display image and its tags when edit page opened' do
    image = create_image

    get :edit, id: image.id

    assert_response :success
    assert_select 'img.js-image-preview' do |elements|
      assert_equal [image.url], elements.map { |el| el[:src] }
    end

    assert_select 'input.form-control' do |elements|
      assert_equal [image.tag_list.join(', ')],
                   elements.map { |el| el[:value] }
    end
  end

  test 'fail to edit when image is not found' do
    assert_raises ActiveRecord::RecordNotFound do
      get :edit, id: -1
    end
  end

  test 'fail to update image with blank tags list' do
    image = create_image

    patch :update, id: image.id, image: { tag_list: '  ' }

    assert_response :unprocessable_entity
    assert_select 'span.help-block' do |elements|
      assert_equal ["can't be blank"], elements.map(&:text)
    end
    assert_select 'form#edit_image_1'
  end

  test 'fail to update when image is not found' do
    assert_raises ActiveRecord::RecordNotFound do
      patch :update, id: -1, image: { tag_list: 'good' }
    end
  end

  test 'fail to update image with url parameter' do
    image = create_image
    patch :update, id: image.id, image: { url: VALID_IMAGE_URL,
                                          tag_list: 'good' }

    assert_response :bad_request
  end

  test 'update an image successfully' do
    image = create_image

    assert_equal %w(tag1 tag2), image.tag_list

    patch :update, id: image.id, image: { tag_list: 'awesome, good' }

    assert_redirected_to image_path(image)
    assert_equal %w(awesome good), image.reload.tag_list

    assert_equal 'You successfully updated the image!', flash[:notice]
  end

  test 'share image successfully' do
    image = create_image
    assert_difference('ActionMailer::Base.deliveries.size', 1) do
      xhr :post, :share, id: image, share_image_form: {
        recipient: 'foo@bar.com', subject: 'Share Image Title' }
    end

    assert_response :success

    share_image_email = ActionMailer::Base.deliveries.last
    assert_equal ['foo@bar.com'], share_image_email.to
    assert_equal 'Share Image Title', share_image_email.subject
  end

  test 'fail to share image with invalid email recipient' do
    image = create_image
    assert_no_difference('ActionMailer::Base.deliveries.size') do
      xhr :post, :share, id: image, share_image_form: {
        recipient: 'invalid', subject: 'Share Image Title' }
    end

    assert_response :unprocessable_entity
    assert_includes JSON.parse(@response.body)['form_html'], 'is invalid'
  end

  test 'fail to share image when image does not exist' do
    assert_no_difference('ActionMailer::Base.deliveries.size') do
      xhr :post, :share, id: -1, share_image_form: {
        recipient: 'foo@bar.com', subject: 'Share Image Title' }
    end

    assert_response :not_found
  end

  private

  def create_image(url: VALID_IMAGE_URL, tag_list: %w(tag1, tag2))
    Image.create!(url: url, tag_list: tag_list)
  end
end
